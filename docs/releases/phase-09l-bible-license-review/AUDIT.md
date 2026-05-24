# VerseLight — Phase 09L Bible Translation License Review

> Audit + remediation phase. Identify copyrighted Bible translation wording
> in the codebase, replace risky quotes with original devotional paraphrases,
> and resolve the long-standing license risk before Amazon Appstore
> submission. KHÔNG sửa signing, keystore, applicationId, versionCode,
> Firebase config, pubspec dependencies, launcher icon, IAP flag, Audio flag,
> hay privacy/store URLs.

## Snapshot

| Field            | Value                                                          |
|------------------|----------------------------------------------------------------|
| Branch / commit  | `main` @ `7585aa7` (Phase 09K — store listing + privacy audit) |
| Working tree     | clean trước khi bắt đầu phase                                  |
| Flutter / Dart   | 3.35.3 stable / Dart 3.9.2                                     |

## Status summary

| Hạng mục                                              | Trạng thái                          |
|-------------------------------------------------------|-------------------------------------|
| Bible verse body text in app data                     | ✅ **RESOLVED** — paraphrased        |
| Translation suffix `(NIV)` in `verseReference`        | ✅ **REMOVED**                       |
| Mock audio title `"Psalm 23 — NIV"`                   | ✅ **REWORDED** (`— narration`)     |
| Affiliate product titles ("NIV Study Bible")          | ✅ Kept — Amazon product name, fair commercial use |
| Devotional reflections / prayer prompts / journals    | ✅ Original VerseLight prose (no scripture quote) |
| Sample audio "Gospel of John (sample)"                | ✅ Title only — no verse text shipped |

---

## 1. Discovery — what was actually in the repo

Searched all of `lib/`, `test/`, `assets/`, `docs/` for:
- Translation tokens: `NIV`, `ESV`, `NABRE`, `NRSV`, `RSV`, `CSB`, `NKJV`, `NLT`, `KJV`, `Douay`, `Knox`.
- Fields holding scripture: `verseText`, `verseReference`.
- Likely-quote shapes: `'"..."'`-wrapped strings in `lib/`.

### 1.1 Bible verse body text shipped in the app data

| File                                                               | Entries | Translation tag (pre-09L) |
|--------------------------------------------------------------------|---------|---------------------------|
| [lib/data/sample_devotionals.dart](../../../lib/data/sample_devotionals.dart) | 10 verses (devo-1 … devo-10) | `(NIV)` on all 10 |
| [lib/data/sample_plans.dart](../../../lib/data/sample_plans.dart)            | 5 plans × 7 days = **35 verses** | `(NIV)` on all 35 |
| [lib/data/sample_audio.dart](../../../lib/data/sample_audio.dart)            | 1 track title `"Psalm 23 — NIV"` | NIV claim in mock title |

**Total exposure: 45 verse-text strings explicitly tagged NIV.**

Sample of pre-09L wording that lined up with the New International Version
(© Biblica, Inc.):
- `Proverbs 3:5 (NIV)` — "Trust in the Lord with all your heart and lean not on your own understanding." (NIV exact phrasing)
- `Lamentations 3:22–23 (NIV)` — "His compassions never fail. They are new every morning; great is your faithfulness." (NIV exact)
- `1 Peter 5:7 (NIV)` — "Cast all your anxiety on him because he cares for you." (NIV exact)
- `Hebrews 11:1 (NIV)` — "Faith is confidence in what we hope for and assurance about what we do not see." (NIV 2011 exact)
- `Ephesians 2:10 (NIV)` — "We are God's handiwork, created in Christ Jesus to do good works…" (NIV exact)
- `Jeremiah 29:11 (NIV)` — "For I know the plans I have for you," declares the Lord, "plans to give you hope and a future." (NIV exact)
- `Matthew 5:9 (NIV)` — "Blessed are the peacemakers, for they will be called children of God." (NIV exact)
- `John 3:16 (NIV)` — "For God so loved the world that he gave his one and only Son." (NIV exact — "one and only" is a NIV-distinctive rendering of μονογενῆ vs. KJV "only begotten")

→ This is unambiguously copyrighted translation wording, attributed explicitly to NIV. The repo was **not** shipping public-domain (KJV / Douay-Rheims Challoner) or licensed Catholic translation (NABRE / RSV-CE / NJB / Knox) text.

### 1.2 Not verse body — safe usages of "NIV" string

| File                                                              | Where                          | Why safe |
|-------------------------------------------------------------------|--------------------------------|----------|
| [lib/services/affiliate_service.dart:14](../../../lib/services/affiliate_service.dart#L14) | Product title `'NIV Study Bible'` in Amazon affiliate listing (ASIN `B07BDCNF2J`) | Naming an existing Amazon-listed product to link to it via affiliate. Nominative commercial use of the product's own published title — not a quote of Bible content. |
| [lib/screens/home_screen.dart:154](../../../lib/screens/home_screen.dart#L154) | `AffiliateBanner(title: 'NIV Study Bible', subtitle: 'Trusted study edition · Amazon')` | Same product-title rationale. The banner links to Amazon; VerseLight is not redistributing NIV scripture. |

→ Kept as-is.

### 1.3 Other content reviewed and cleared

| File / area                                                                 | Finding |
|-----------------------------------------------------------------------------|---------|
| `Devotional.reflection`, `prayerPrompt`, `journalPrompt`, `actionStep`, `preview`, `title` | All original VerseLight prose — no scripture quotation. Cleared. |
| `PlanDay.reflection`, `actionStep`, `title`                                 | Same. Cleared. |
| `lib/widgets/daily_verse_card.dart`, `lib/widgets/verse_card.dart`          | UI renders `verseText` / `verseRef` from data; contains no hard-coded verse text. Cleared. |
| `lib/services/ai_service.dart`                                              | Placeholder — does not return any Bible text. Cleared. |
| `assets/images/devotional/`                                                 | Watercolor artwork only; no embedded text per image asset brief. Cleared. |
| `test/*.dart`                                                               | Only checks counts and ids, never asserts verse text strings. Cleared (also: no test will break from rewording). |
| `docs/`                                                                     | Two pre-existing audit files mention NIV historically; left intact as audit trail. |

### 1.4 Translations / copyright owners — quick reference

| Translation                               | Status                              |
|-------------------------------------------|-------------------------------------|
| KJV (King James Version)                  | Public domain in the US (UK Crown copyright via Cambridge UP — irrelevant for US-focused Amazon listing). |
| Douay-Rheims Challoner (1899)             | Public domain. Catholic.            |
| NIV (New International Version)           | © Biblica, Inc. License required for commercial app distribution. |
| ESV (English Standard Version)            | © Crossway. License required.       |
| NABRE (New American Bible Revised Edition)| © USCCB. License required.          |
| RSV-CE / RSV-2CE                          | © Ignatius Press / NCCC. License required. |
| NRSV / NRSVue                             | © NCCC. License required.           |
| CSB / NKJV / NLT                          | Licensed translations, all require permission for app distribution. |

VerseLight has **no** signed agreement with Biblica or any other translation publisher.

---

## 2. Decision

**Strip all copyrighted translation wording. Ship only original devotional paraphrases.**

Rationale:
1. The task brief explicitly authorizes this remediation path: *"If text is unclear or likely copyrighted, replace with original paraphrase/devotional prose, or replace verse body with reference-only text."* The NIV exposure is not unclear — it is explicit.
2. Removing the verse body entirely would break the in-app reading experience (cards would render empty quotes). Paraphrase preserves UX continuity.
3. A licensed translation rollout (e.g. NABRE for the Catholic audience) is a multi-month legal + financial workstream; it should not block Amazon submission.
4. Public-domain Douay-Rheims (Challoner) was considered as a drop-in. Rejected for now because the archaic register ("thee/thou") clashes with the modern devotional tone of the existing reflections; can be revisited as a follow-up if the team prefers literal scripture over paraphrase.
5. Paraphrase keeps `verseReference` (Book Chapter:Verse) so users can open their own Bible in their preferred / licensed translation.

### 2.1 Paraphrase rules applied

Each paraphrase was written for this PR with the following constraints:
- Captures the underlying biblical theme (same Book Chapter:Verse pointer).
- Does **not** copy distinctive wording from NIV / ESV / NABRE / RSV / NRSV / CSB / NKJV / NLT.
- 1 sentence, modern English, devotional in tone.
- Avoids translation-distinctive phrases (e.g. NIV's "one and only Son" → "only Son"; NIV's "Trust in the Lord with all your heart" → "Lean on God with the whole of who you are…").
- For verses where many translations historically converge on identical short phrasings (e.g. Psalm 46:10 "Be still, and know that I am God" appears in both KJV public-domain and NIV), the paraphrase still rewords to avoid relying on a same-wording-across-translations defense.

Every paraphrase in `sample_devotionals.dart` / `sample_plans.dart` is original to the VerseLight project — copyright held by the project, no license owed to any external publisher.

### 2.2 What was kept untouched

- `verseReference` references like `Psalm 23:1` — these are short factual book/chapter/verse pointers and are not copyrightable.
- Affiliate product titles ("NIV Study Bible", "Jesus Calling", etc.) — commerical product names, used to link to the actual Amazon product via affiliate. Not VerseLight content.
- All UI widgets (`daily_verse_card.dart`, `verse_card.dart`, etc.) — still wrap `verseText` in visual quote marks. This is consistent with how the field reads as a devotional reflective line; can be reconsidered (e.g. drop the wrapping quotes since the text is paraphrase, not verse) in a UI polish phase if needed.
- Model classes (`Devotional`, `PlanDay`) — field names kept the same to preserve persistence keys.

---

## 3. Files changed

| File                                                                  | Change |
|-----------------------------------------------------------------------|--------|
| [lib/data/sample_devotionals.dart](../../../lib/data/sample_devotionals.dart) | Added licensing header comment. Rewrote all 10 `verseText` strings as paraphrase. Stripped `(NIV)` suffix from all 10 `verseReference` strings. Fixed verse 4 actionStep that quoted the verse verbatim ("repeat this verse" → "rest in this verse"). |
| [lib/data/sample_plans.dart](../../../lib/data/sample_plans.dart)             | Added licensing header comment. Rewrote all 35 `verseText` strings as paraphrase. Stripped `(NIV)` suffix from all 35 `verseReference` strings. |
| [lib/data/sample_audio.dart](../../../lib/data/sample_audio.dart)             | Renamed mock track title `"Psalm 23 — NIV"` → `"Psalm 23 — narration"` (Audio tab still hidden by Phase 09J's `kEnableAudioTab=false`, so user-facing impact zero either way). |
| [docs/releases/phase-09l-bible-license-review/AUDIT.md](AUDIT.md)             | NEW — this audit document. |
| [docs/releases/phase-09e-amazon-readiness/KNOWN_ISSUES.md](../phase-09e-amazon-readiness/KNOWN_ISSUES.md) | Mark issue #7 as RESOLVED with reference to this phase. |

**Không** thay đổi: signing, keystore, `key.properties`, `applicationId`, namespace, `versionCode`/`versionName`, Firebase config, `google-services.json`, `firebase_options.dart`, pubspec dependencies, launcher icon, IAP flag, Audio flag, privacy/store URLs, model classes (`Devotional`, `PlanDay`, `ReadingPlan`), UI widgets, content filters, services.

---

## 4. Verification

| Command                       | Result                                                         |
|-------------------------------|----------------------------------------------------------------|
| `flutter analyze`             | ✅ `No issues found! (ran in 4.2s)`                            |
| `flutter test`                | ✅ All 13 tests passed (content-library tests assert ids+counts, not verse text — unaffected) |
| `flutter build apk --release` | ✅ `Built build\app\outputs\flutter-apk\app-release.apk (51.4MB)` |
| `git diff --check`            | ✅ no whitespace errors                                        |
| `git status --short`          | 3 modified data files + 1 modified docs file + 1 new docs dir  |
| `git diff --stat`             | dominated by `sample_plans.dart` + `sample_devotionals.dart` paraphrase rewrites; new `AUDIT.md`; small touch in `sample_audio.dart`; small update in `KNOWN_ISSUES.md` |

Persistence safety: stable ids (`devo-1` … `devo-10`, `plan-nt-30`, …, `plan-gratitude-7`) preserved. Existing users keep their progress/journal entries; the content text they re-open after upgrade simply shows a paraphrase instead of a NIV quote. Local storage migration is a no-op.

---

## 5. Store / privacy / legal implication

- **Copyright exposure:** removed. App ships zero copyrighted Bible translation wording. No license owed to Biblica, Crossway, USCCB, NCCC, Ignatius Press, etc.
- **Amazon Appstore content policy:** improves alignment. Religion category submissions are scrutinized for unlicensed scripture redistribution; this remediation removes that specific failure mode.
- **Privacy / data collection:** unchanged. No new permissions, no network calls, no analytics — Phase 09I/09K disclosure profile still applies.
- **UX impact:** verse text on cards now reads as a brief devotional paraphrase rather than a NIV quote. Users who want the canonical wording have the verse reference (e.g. `Proverbs 3:5`) and can open their own Bible app.
- **Affiliate disclosure:** unchanged. Amazon Associates link to "NIV Study Bible" product is unaffected — that's a product link, not a content quote.
- **Bible reference attribution:** for a Catholic-leaning devotional app, a future phase may want to wire NABRE (preferred Catholic US translation) under a USCCB license. That is **not** a blocker for first submission.

---

## 6. Next-phase recommendations (out of scope here)

1. (Optional UX polish.) Reconsider whether `verse_card.dart` and `daily_verse_card.dart` should keep wrapping `verseText` in visual `"…"` quote marks now that the field stores a paraphrase rather than a quotation.
2. (Optional content.) Decide whether to license NABRE (USCCB), RSV-CE (Ignatius), or revert to public-domain Douay-Rheims Challoner for the canonical verse pane. Either path requires a follow-up content swap and a translation suffix back in `verseReference`.
3. (Owner action from Phase 09K, still open.) Land final privacy/terms/help/support URLs and final Amazon Associates tag.
4. (Owner action from Phase 09E #8, still open.) Pick `versionCode` bump strategy before first store submission.
5. (Owner action from Phase 09K, still open.) Produce 512×512 store icon export, 1024×500 banner, ≥3 phone + ≥3 Fire HD 8 screenshots, short + long description copy.

Phase 09L closes the longest-standing legal risk in the project. Combined with Phase 09H (mock IAP gated), 09I (INTERNET permission + Firebase decision), 09J (Audio tab gated), and 09K (privacy/listing audit), VerseLight's code-side store-blocker checklist is now empty. Remaining blockers are owner-driven asset / URL / license-tag deliverables.
