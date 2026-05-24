# VerseLight -- Amazon Submission APK Build Script (Phase 09S+)
#
# Builds a release-signed APK ready for upload to Amazon Appstore (or any
# other Android store) from a known-good clean state. Designed to defeat
# the Gradle incremental-build cache that bit Phases 09O, 09P, and 09R
# (incremental builds short-circuited and produced APKs with stale Dart
# code -- paraphrased verses missing, hidden tabs still visible, etc.).
#
# Usage (run from repo root):
#   PowerShell -ExecutionPolicy Bypass -File scripts\build-submission-apk.ps1
#
# What it does:
#   1. Hard-cleans every cache layer that has been observed to short-circuit:
#      build\, .dart_tool\, android\.gradle\, android\app\build\
#   2. flutter pub get
#   3. flutter analyze (fail-fast on lint/type errors)
#   4. flutter test    (fail-fast on test failures)
#   5. flutter build apk --release
#   6. Warns if Gradle build finished suspiciously fast (< 25 s) -- that's
#      the cache-short-circuit signature; the operator should investigate
#      before treating the APK as fresh.
#   7. Prints the APK path, size, and SHA-256.
#   8. If aapt is on PATH, prints the package, versionCode, versionName,
#      sdkVersion, targetSdkVersion, application-label, and uses-permission
#      list dumped from the APK itself. If aapt is missing, prints the
#      exact command the operator must run manually.
#   9. If apksigner is on PATH (and java is reachable), verifies the APK
#      signature and prints the signer DN + SHA-256 cert digest. If either
#      is missing, prints the exact command + JAVA_HOME hint to run
#      manually. Never fakes a verification result.
#
# Exit codes:
#   0  build + all available verifications passed
#   1  any step failed (clean, pub get, analyze, test, build, hash)
#   2  build succeeded but at least one external verifier (aapt /
#      apksigner) is missing -- APK is on disk, operator must run the
#      printed manual command before upload.
#
# This script does NOT install the APK on any device, does NOT upload
# anywhere, does NOT touch git state, and does NOT modify the keystore
# or key.properties.

$ErrorActionPreference = 'Stop'

# Resolve repo root (parent of the scripts/ folder this script lives in).
$RepoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $RepoRoot

Write-Host "===============================================================" -ForegroundColor Cyan
Write-Host "VerseLight Amazon Submission APK Build" -ForegroundColor Cyan
Write-Host "Repo: $RepoRoot" -ForegroundColor Cyan
Write-Host "===============================================================" -ForegroundColor Cyan

# ---- 1. Hard clean ---------------------------------------------------------
Write-Host "`n[1/9] Hard-cleaning Flutter + Gradle caches..." -ForegroundColor Yellow

# Run flutter clean first so the tool releases any file handles it holds.
flutter clean | Out-Null

$cachesToWipe = @(
    'build',
    '.dart_tool',
    'android\.gradle',
    'android\app\build'
)
foreach ($cache in $cachesToWipe) {
    if (Test-Path $cache) {
        try {
            Remove-Item -Recurse -Force $cache -ErrorAction Stop
            Write-Host "  wiped: $cache"
        } catch {
            # Some Gradle daemon lock files refuse to delete. Don't fail the
            # whole build over a stale lock -- flutter build will still
            # invalidate the matching outputs.
            Write-Host "  WARN: could not fully wipe $cache ($($_.Exception.Message))" -ForegroundColor Yellow
        }
    }
}

# ---- 2. pub get ------------------------------------------------------------
Write-Host "`n[2/9] flutter pub get..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) { exit 1 }

# ---- 3. analyze ------------------------------------------------------------
Write-Host "`n[3/9] flutter analyze..." -ForegroundColor Yellow
flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "ABORT: flutter analyze reported issues." -ForegroundColor Red
    exit 1
}

# ---- 4. test ---------------------------------------------------------------
Write-Host "`n[4/9] flutter test..." -ForegroundColor Yellow
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "ABORT: flutter test failed." -ForegroundColor Red
    exit 1
}

# ---- 5. build --------------------------------------------------------------
Write-Host "`n[5/9] flutter build apk --release..." -ForegroundColor Yellow
$buildStart = Get-Date
flutter build apk --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "ABORT: flutter build apk --release failed." -ForegroundColor Red
    exit 1
}
$buildElapsed = (Get-Date) - $buildStart
$buildSeconds = [int]$buildElapsed.TotalSeconds
Write-Host "  build elapsed: $buildSeconds s"

# ---- 6. Cache-shortcircuit warning ----------------------------------------
# Phases 09O / 09P / 09R observed Gradle finishing in 4–13 s after a flutter
# clean and producing an APK with stale Dart code. A fresh release build of
# this project takes ~50–80 s. Anything under 25 s after a hard clean is
# suspicious and the operator should investigate before treating the APK
# as a real submission artifact.
if ($buildSeconds -lt 25) {
    Write-Host ""
    Write-Host "!!! CACHE-SHORTCIRCUIT WARNING !!!" -ForegroundColor Red
    Write-Host "Build finished in ${buildSeconds}s after a hard clean." -ForegroundColor Red
    Write-Host "A real fresh build of this project takes 50-80s." -ForegroundColor Red
    Write-Host "The APK may contain stale Dart code (Phases 09O/09P/09R)." -ForegroundColor Red
    Write-Host "Do NOT upload this APK without investigating." -ForegroundColor Red
    Write-Host "Re-run this script after stopping any Gradle daemons:" -ForegroundColor Yellow
    Write-Host "  cd android; .\gradlew --stop; cd .." -ForegroundColor Yellow
    Write-Host ""
}

# ---- 7. APK metadata -------------------------------------------------------
$apk = Join-Path $RepoRoot 'build\app\outputs\flutter-apk\app-release.apk'
if (-not (Test-Path $apk)) {
    Write-Host "ABORT: APK not produced at expected path." -ForegroundColor Red
    exit 1
}

Write-Host "`n[6/9] APK metadata..." -ForegroundColor Yellow
$apkInfo = Get-Item $apk
$apkSizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
$apkHash = (Get-FileHash $apk -Algorithm SHA256).Hash
Write-Host "  path        : $apk"
Write-Host "  size        : $($apkInfo.Length) bytes ($apkSizeMB MB)"
Write-Host "  modified    : $($apkInfo.LastWriteTime)"
Write-Host "  sha256      : $apkHash"

# ---- 8. aapt verify --------------------------------------------------------
Write-Host "`n[7/9] aapt verification..." -ForegroundColor Yellow

function Find-LatestBuildTool {
    param([string]$ToolName)
    $btRoot = "$env:LOCALAPPDATA\Android\sdk\build-tools"
    if (-not (Test-Path $btRoot)) {
        $btRoot = "$env:USERPROFILE\AppData\Local\Android\sdk\build-tools"
    }
    if (-not (Test-Path $btRoot)) { return $null }
    $latest = Get-ChildItem $btRoot -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latest) { return $null }
    foreach ($ext in @('.exe', '.bat', '')) {
        $candidate = Join-Path $latest.FullName "$ToolName$ext"
        if (Test-Path $candidate) { return $candidate }
    }
    return $null
}

$aapt = Find-LatestBuildTool -ToolName 'aapt'
$aaptOk = $false
if ($aapt) {
    try {
        $aaptOut = & $aapt dump badging $apk 2>$null
        if ($LASTEXITCODE -eq 0 -and $aaptOut) {
            $aaptOk = $true
            Write-Host "  tool: $aapt"
            $aaptOut | Where-Object {
                $_ -match '^(package:|sdkVersion:|targetSdkVersion:|application-label:''[^'']+''$|uses-permission:)'
            } | Select-Object -First 12 | ForEach-Object {
                Write-Host "  $_"
            }
        } else {
            Write-Host "  WARN: aapt found but dump failed." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  WARN: aapt invocation failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
if (-not $aaptOk) {
    Write-Host "  aapt not found on disk. Manual verify:" -ForegroundColor Yellow
    Write-Host "    <android-sdk>\build-tools\<latest>\aapt dump badging `"$apk`"" -ForegroundColor Yellow
    Write-Host "  Expected: package='com.versestudio.verselight' versionCode='10' versionName='1.0.0'" -ForegroundColor Yellow
}

# ---- 9. apksigner verify ---------------------------------------------------
Write-Host "`n[8/9] apksigner signature verification..." -ForegroundColor Yellow

$apksigner = Find-LatestBuildTool -ToolName 'apksigner'
$apksignerOk = $false

# Resolve a JAVA_HOME for apksigner if one isn't already set.
if (-not $env:JAVA_HOME -or -not (Test-Path $env:JAVA_HOME)) {
    $candidateJdk = "C:\Program Files\Android\Android Studio\jbr"
    if (Test-Path $candidateJdk) {
        $env:JAVA_HOME = $candidateJdk
        $env:PATH = "$candidateJdk\bin;$env:PATH"
    }
}

if ($apksigner) {
    try {
        $signerOut = & $apksigner verify --print-certs $apk 2>&1
        if ($LASTEXITCODE -eq 0) {
            $apksignerOk = $true
            Write-Host "  tool: $apksigner"
            $signerOut | Where-Object {
                $_ -match '^(Verified|Signer #1 certificate (DN|SHA-256))'
            } | ForEach-Object {
                Write-Host "  $_"
            }
            Write-Host "  Expected cert SHA-256: 2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c" -ForegroundColor Cyan
            Write-Host "  (Phase 09G upload key -- must match exactly for store updates to install.)" -ForegroundColor Cyan
        } else {
            Write-Host "  WARN: apksigner returned non-zero exit. Output:" -ForegroundColor Yellow
            $signerOut | ForEach-Object { Write-Host "    $_" }
        }
    } catch {
        Write-Host "  WARN: apksigner invocation failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
if (-not $apksignerOk) {
    Write-Host "  apksigner not runnable. Manual verify:" -ForegroundColor Yellow
    Write-Host "    set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr" -ForegroundColor Yellow
    Write-Host "    <android-sdk>\build-tools\<latest>\apksigner verify --print-certs `"$apk`"" -ForegroundColor Yellow
    Write-Host "  Expected: Signer #1 cert SHA-256 = 2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c" -ForegroundColor Yellow
}

# ---- 10. Summary -----------------------------------------------------------
Write-Host "`n[9/9] Summary" -ForegroundColor Yellow
Write-Host "  APK         : $apk"
Write-Host "  SHA-256     : $apkHash"
Write-Host "  Build time  : ${buildSeconds}s"
Write-Host "  aapt verify : $(if ($aaptOk) { 'OK' } else { 'SKIPPED (manual required)' })"
Write-Host "  apksigner   : $(if ($apksignerOk) { 'OK' } else { 'SKIPPED (manual required)' })"
Write-Host "==============================================================="

if (-not ($aaptOk -and $apksignerOk)) {
    Write-Host "DONE with WARNINGS: at least one external verifier was skipped." -ForegroundColor Yellow
    Write-Host "Run the printed manual command before treating this APK as submission-ready." -ForegroundColor Yellow
    exit 2
}

Write-Host "DONE: APK built and verified. Safe to inspect for store upload." -ForegroundColor Green
exit 0
