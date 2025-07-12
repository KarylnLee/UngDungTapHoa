document.addEventListener("DOMContentLoaded", function () {
  const sendOtpBtn = document.getElementById("sendOtpBtn");
  const verifyOtpBtn = document.getElementById("verifyOtpBtn");

  let generatedOtp = "";

  // B1: Gửi OTP
  sendOtpBtn.addEventListener("click", async () => {
    const email = document.getElementById("email").value.trim();
    if (!email) return alert("❗ Vui lòng nhập email.");

    generatedOtp = Math.floor(100000 + Math.random() * 900000).toString();

    const otpPayload = {
      type: email, // <- Sử dụng email làm trường type để gửi OTP đến đúng địa chỉ
      code: generatedOtp,
      expiry: new Date(Date.now() + 5 * 60000).toISOString(), // +5 phút
      userId: 0 // nếu chưa đăng ký thì userId = 0 hoặc null
    };

    try {
      const res = await fetch("http://localhost:5257/api/otp/send", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(otpPayload)
      });

      if (res.ok) {
        alert("📧 Mã OTP đã được gửi qua email!");
        document.getElementById("otpSection").style.display = "block";
      } else {
        alert("❌ Không thể gửi mã OTP.");
      }
    } catch (err) {
      alert("❌ Lỗi kết nối đến máy chủ.");
      console.error(err);
    }
  });

  // B2: Xác nhận OTP và đăng ký
  verifyOtpBtn.addEventListener("click", async () => {
    const otpInput = document.getElementById("otp").value.trim();
    if (otpInput !== generatedOtp) return alert("❌ Mã OTP không đúng.");

    const fullname = document.getElementById("fullname").value.trim();
    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const password = document.getElementById("password").value;
    const confirmPassword = document.getElementById("confirmPassword").value;

    if (!fullname || !email || !phone || !password || !confirmPassword)
      return alert("❗ Vui lòng điền đầy đủ thông tin.");

    if (password !== confirmPassword)
      return alert("⚠️ Mật khẩu nhập lại không khớp.");

    try {
      const res = await fetch("http://localhost:5257/api/auth/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
        fullName: fullname,
        email: email.trim().toLowerCase(),
        phoneNumber: phone,
        password: password,  
        authProvider: "local"   
      })

      });

      if (res.ok) {
        alert("✅ Đăng ký thành công!");
        window.location.href = "login.html";
      } else {
        alert("❌ Đăng ký thất bại. Email có thể đã tồn tại.");
      }
    } catch (err) {
      alert("❌ Lỗi kết nối đến máy chủ.");
      console.error(err);
    }
  });
});
