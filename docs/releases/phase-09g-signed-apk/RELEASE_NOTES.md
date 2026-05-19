# VerseLight — Phase 09G Signed Beta Release Notes

> Phase 09G output: **release-signed** APK using the VerseLight upload keystore.
> This is the first VerseLight APK that is **NOT** signed with the Android debug key
> — it is suitable for tester sideload **and** for Amazon Appstore upload pipeline
> testing (with caveats below).

## Build info

| Field            | Value                                                              |
|------------------|--------------------------------------------------------------------|
| Version          | `1.0.0+1` (pubspec) — versionName=`1.0.0`, versionCode=`1`         |
| Source commit    | `a07dbf17fb3358606dea740277a5e8f18a44d7fa` (branch `main`, HEAD before Phase 09G commit) |
| Build type       | Android release APK (`flutter build apk --release`)                |
| Signing          | **Upload keystore (release-signed)** — see cert below              |
| applicationId    | `com.versestudio.verselight`                                       |
| Flutter / Dart   | 3.35.3 stable / Dart 3.9.2                                         |
| Min Android      | API 24 (Android 7.0 Nougat)                                        |
| Target Android   | API 36 (Android 16)                                                |
| APK file         | `VerseLight-v1.0.0-signed-beta-android.apk`                        |
| APK size         | 53,979,781 bytes (~51.5 MB)                                        |
| APK SHA256       | `0FE1A808FD74D6ACC7EBF1C510C47A3EDBEA543A15A50B46229201849BFFA041` |
| Generated        | 2026-05-19 21:58 +07:00                                            |

> APK binary is gitignored. Only this `RELEASE_NOTES.md` and the
> `*.sha256.txt` sibling are tracked in git.

## Certificate verification

Output of `apksigner verify --print-certs build\app\outputs\flutter-apk\app-release.apk`:

```
Signer #1 certificate DN: CN=VerseLight, OU=Mobile, O=Verse Studio, L=Bien Hoa, ST=Dong Nai, C=VN
Signer #1 certificate SHA-256 digest: 2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c
Signer #1 certificate SHA-1   digest: 9a1a8a4b6302d15b8fb06ec2fd4ebd9fea8c648f
Signer #1 certificate MD5     digest: e9337726bba2cf62ab1d2c6eb65b19de
```

- ✅ Cert DN matches `VerseLight / Verse Studio` — **NOT** `CN=Android Debug, O=Android, C=US`.
- ✅ Cert validity 25 years (per keystore generation parameters in Phase 09F).
- ✅ Signature scheme: v1 + v2 (Flutter Gradle default).

These cert fingerprints (SHA-256 / SHA-1) are now the **identity of VerseLight on Android**.
Every future release MUST be signed with this same keystore — otherwise existing
installations cannot be updated and have to be uninstalled+reinstalled.

## How to verify APK integrity (recipient side)

**Windows PowerShell:**

```powershell
Get-FileHash .\VerseLight-v1.0.0-signed-beta-android.apk -Algorithm SHA256
```

**macOS / Linux:**

```bash
shasum -a 256 VerseLight-v1.0.0-signed-beta-android.apk
```

Hash must equal:

```
0FE1A808FD74D6ACC7EBF1C510C47A3EDBEA543A15A50B46229201849BFFA041
```

**Optionally verify signature** (Android SDK build-tools required):

```bash
apksigner verify --print-certs VerseLight-v1.0.0-signed-beta-android.apk
```

Confirm cert SHA-256 matches `2abe1d8694aedc71bd83fbe44d33e3c5ef172380a71ac0b98b45468da98cf96c`.

## Difference vs. Phase 09D debug-fallback beta

| Aspect                | Phase 09D (`...beta-android.apk`)             | Phase 09G (`...signed-beta-android.apk`)         |
|-----------------------|-----------------------------------------------|--------------------------------------------------|
| Signing cert          | `CN=Android Debug, O=Android, C=US` (debug)   | `CN=VerseLight, …, O=Verse Studio` (upload key)  |
| Cert validity         | ~365 days (Android debug default)             | 9125 days (~25 years)                            |
| Store upload eligible | ❌                                            | ✅ (from signing perspective)                    |
| Tester sideload       | ✅                                            | ✅                                                |
| SHA256                | `33450A32…07214`                              | `0FE1A808…A041`                                  |
| Cert SHA-256          | (Android Debug — different per machine)       | `2abe1d86…f96c` (stable forever)                 |
| Source commit         | `74648e7` (pre-Phase-09F)                     | `a07dbf1` (post-Phase-09F)                       |

→ Recipients who installed Phase 09D APK will **need to uninstall** before installing 09G,
because the signing cert changed. (Android refuses installs that change the cert under the
same package name — by design, to prevent malicious overwrite.)

## Still NOT production-ready

Signing is resolved. The other store-blockers from
[Phase 09E known issues](../phase-09e-amazon-readiness/KNOWN_ISSUES.md) remain:

- 🔴 **IAP still mock** — `IapService` does not call any real billing SDK; tester
  may "Subscribe (mock)" with no money flow. Must be wired to Amazon IAP (or Play
  Billing) before public store submission. → Phase 09H scope.
- 🟡 `android.permission.INTERNET` missing from release merged manifest — latent,
  fine for current beta but breaks once Firebase/IAP network calls are added. → Phase 09I.
- 🟡 Firebase `firebase_core` initialized but unused → Phase 09I.
- 🟡 Audio tab is mock UI → Phase 09J.
- ⚠️ Store listing assets (screenshots, feature graphic, description, privacy policy,
  age rating) not prepared → Phase 09K.

→ Phase 09G's signed APK is **usable for**:
- Internal beta tester sideload (preferred over Phase 09D debug-signed).
- Amazon Appstore upload **pipeline dry-run** (creating draft listing, confirming
  Amazon's APK ingestion accepts the cert).
- It is **NOT yet ready for public production release** because of mock IAP.

## ⚠️ Do not lose the keystore

The upload keystore lives at:

```
%USERPROFILE%\.android\verselight-upload-key.jks
```

— OUTSIDE this repo, gitignored at multiple levels.

If this `.jks` file is lost or its password is forgotten:

- Amazon Appstore: **cannot push any update** to a published VerseLight app. Would
  have to submit as a new app under a different `applicationId`, breaking all
  existing user installs (lost streaks, lost journal data persisted under the old
  package).
- The cert SHA-256 (`2abe1d86…f96c`) recorded in this file is the only public
  identity of the app — without the keystore, even knowing the fingerprint does
  not help.

**Protect the keystore the same way you'd protect a production private SSH key:**

1. Password in a password manager (1Password / Bitwarden / KeePass).
2. Encrypted backup of the `.jks` file in ≥ 2 places (encrypted USB + encrypted
   cloud bucket whose key you control).
3. Never email/Slack/Discord/Telegram the file.
4. Never store it in OneDrive/iCloud/Dropbox default-sync folders unless they
   are explicitly encrypted vaults.

See [`docs/releases/phase-09f-release-signing/RELEASE_SIGNING.md`](../phase-09f-release-signing/RELEASE_SIGNING.md) section 7 for the full recovery scenarios.

## Recommended next phase

**Phase 09H — Wire real IAP** (Amazon IAP via platform channel, or Google Play
Billing via `in_app_purchase`). Once IAP is real, this same signed APK pipeline
produces a true store-submittable build.
