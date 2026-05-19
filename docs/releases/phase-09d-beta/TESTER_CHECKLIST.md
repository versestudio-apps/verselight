# VerseLight Beta — Tester Checklist (Phase 09D)

Cảm ơn bạn đã giúp test bản beta VerseLight. Vui lòng làm theo các bước bên dưới và đánh dấu Pass/Fail vào ô [ ]. Nếu gặp bất kỳ lỗi nào, dùng mẫu báo lỗi ở mục **I** ở cuối file.

- **File APK:** `VerseLight-v1.0.0-beta-android.apk`
- **SHA256:** `33450A323568DB86CD80B7D05BC3E8D20644E2022D6C1D56A64AFAFDCAF07214`
- **Build type:** Android release APK (chưa publish Store)
- **Yêu cầu:** Android 7.0 (API 24) trở lên

---

## A. Cài đặt

- [ ] Tải file `VerseLight-v1.0.0-beta-android.apk` về máy Android.
- [ ] Mở Trình quản lý file, bấm vào file APK để cài.
- [ ] Nếu Android cảnh báo **"Cài đặt từ nguồn không xác định"**, bật quyền "Cho phép ứng dụng này cài đặt" cho trình duyệt/file manager bạn đang dùng, sau đó quay lại bấm Cài.
- [ ] Cài thành công, không có lỗi parse / "App not installed".
- [ ] Mở app sau khi cài (bấm Open hoặc tìm icon "VerseLight" trên màn hình chính).

---

## B. Launch / Branding

- [ ] Icon app trên màn hình chính là logo VerseLight (nền kem + biểu tượng Kinh Thánh & Thánh giá), KHÔNG phải icon Flutter default màu xanh.
- [ ] Tên app dưới icon hiển thị đúng là **"VerseLight"**.
- [ ] Khi mở app, splash screen có **nền kem ấm + biểu tượng VerseLight căn giữa**, không phải màn trắng / đen / xanh trống.
- [ ] Sau splash, có màn loading hiển thị **"VerseLight"** (chữ serif) + dòng tagline **"A quiet moment with God"** + vòng xoay loading nhỏ màu vàng.
- [ ] App vào màn Home không bị crash / không bị treo loading vô hạn.

---

## C. Các tab chính

Bottom navigation có các tab. Hãy bấm từng tab và xác nhận mở được, không crash, không trắng màn:

- [ ] **Home**
- [ ] **Devotional**
- [ ] **Journal**
- [ ] **Plans**
- [ ] **Audio**
- [ ] **Shop**
- [ ] Mở **Settings** (icon bánh xe / tune ở góc trên Home)
- [ ] Mở **Paywall / Premium** (icon ngôi sao / sparkle ở góc trên Home)

---

## D. Devotional

- [ ] Tab Devotional hiển thị danh sách các devotional theo ngày/chủ đề.
- [ ] Ảnh thumbnail của từng devotional **không bị tràn, không bị cắt méo**, viền card đều.
- [ ] Bấm vào một devotional → mở chi tiết.
- [ ] Trong màn chi tiết: ảnh ngang ở đầu trang **vừa khung, không bị crop quá đáng**, không có viền lạ.
- [ ] Có thể cuộn nội dung devotional bình thường.
- [ ] Nếu có nút **"Mark as read" / "Đánh dấu đã đọc"** → bấm thử, app phản hồi (vd: streak tăng / icon completed).

---

## E. Plans

- [ ] Tab Plans hiển thị danh sách reading plans (Bible journeys).
- [ ] Ảnh từng plan **không bị tràn / méo**, card hiển thị tiêu đề + mô tả rõ.
- [ ] Bấm vào một plan → mở chi tiết plan.
- [ ] Trong chi tiết: ảnh banner plan **vừa khung**, danh sách các ngày đọc hiển thị đầy đủ.
- [ ] Nếu có nút **"Mark day complete" / tick ngày đọc** → bấm thử, app phản hồi.

---

## F. Journal / Local data

- [ ] Mở tab Journal.
- [ ] Thêm 1 note hoặc 1 lời nguyện mới (nhập text, lưu).
- [ ] Note vừa thêm hiển thị trong danh sách.
- [ ] Nếu có nút **Copy** / **Delete** → thử, hoạt động đúng.
- [ ] **Đóng app hoàn toàn** (vuốt khỏi recent apps), mở lại → note vừa thêm vẫn còn (dữ liệu local persisted).
- [ ] Streak ngày đọc (nếu có) vẫn đúng sau khi mở lại app.

---

## G. Premium / Paywall (mock)

> **Lưu ý:** IAP trong bản beta này đang là **mock** — KHÔNG được phép thanh toán thật.

- [ ] Mở 1 nội dung premium (vd: devotional/plan có khóa) → paywall hiển thị.
- [ ] Paywall hiển thị đúng giá / mô tả / nút subscribe (mock).
- [ ] Bấm thử **Subscribe (mock)** → entitlement được mở, nội dung premium unlock.
- [ ] Bấm thử **Restore purchases** (nếu có) → không crash, không bị treo.
- [ ] **KHÔNG** test bằng thẻ tín dụng thật / tài khoản Google Play thật.

---

## H. Audio / Shop

- [ ] Tab Audio: mở 1 item audio.
- [ ] Now Playing / mock playback hiển thị (title, control play/pause).
- [ ] Bấm play/pause (mock) — không crash.
- [ ] Tab Shop: affiliate banner (Amazon book / Audible) hiển thị đúng tiêu đề / mô tả.
- [ ] Bấm banner → mở browser / link affiliate (chấp nhận được nếu chỉ mở Amazon).

---

## I. Mẫu báo lỗi

Nếu phát hiện lỗi, copy mẫu sau và điền:

```
- Thiết bị (model):
- Android version:
- Bước tái hiện lỗi (1, 2, 3...):
- Kết quả kỳ vọng:
- Kết quả thực tế:
- Screenshot / video (đính kèm link):
- Có bị crash (app đóng đột ngột) không? Yes / No
- Tần suất: Mỗi lần / Thỉnh thoảng / Chỉ 1 lần
- Ghi chú thêm:
```

---

## J. Kết luận tester

Khoanh / tick 1 trong 3:

- [ ] **Pass** — Đủ tốt để chuyển sang vòng beta tiếp theo / chuẩn bị submit store.
- [ ] **Pass with notes** — Đủ dùng, nhưng có vài điểm nhỏ ghi chú bên dưới.
- [ ] **Fail** — Có lỗi blocker, cần sửa trước beta tiếp theo.

**Ghi chú chung của tester:**

```
(Viết cảm nhận tổng thể, UI/UX, hiệu năng, độ ổn định, gợi ý cải thiện...)
```

---

Cảm ơn bạn rất nhiều. Gửi lại checklist này (kèm screenshot/video nếu có) cho team VerseLight qua kênh đã thống nhất.
