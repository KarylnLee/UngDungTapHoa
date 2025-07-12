document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("loginForm");

  form.addEventListener("submit", async function (e) {
    e.preventDefault();

    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();

    try {
      const res = await fetch("http://localhost:5257/api/Auth/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ Email: email, Password: password }),
      });

      const raw = await res.text();
      console.log("🧾 RAW RESPONSE:", raw);

      if (!res.ok) {
        alert(`❌ Sai tài khoản hoặc mật khẩu. Mã lỗi: ${res.status}`);
        return;
      }

      let data;
      try {
        data = JSON.parse(raw);
      } catch (err) {
        console.error("❌ Không parse được JSON:", err, "Raw data:", raw);
        alert("Lỗi định dạng phản hồi từ server.");
        return;
      }

      console.log("✅ DỮ LIỆU LOGIN:", data);

      // 👉 Lấy token
      let jwt = data.token;
      if (!jwt || typeof jwt !== "string") {
        alert("⚠️ Token không hợp lệ hoặc không tồn tại.");
        console.warn("TOKEN:", jwt);
        return;
      }

      // ✅ Lưu thông tin vào localStorage
      const userId = data.user.userId;
      localStorage.setItem("userId", userId);
      localStorage.setItem("userFullName", data.user.fullName);
      localStorage.setItem("userEmail", data.user.email);
      localStorage.setItem("token", jwt);

      // 👉 Kiểm tra vai trò từ API hoặc database
      const isAdmin = await checkAdminRole(userId, jwt);
      console.log("Kết quả kiểm tra admin:", isAdmin);

      // ✅ Điều hướng theo hai luồng
      if (isAdmin) {
        window.location.href = "../page/admin/dashboard.html";
      } else {
        window.location.href = "../index.html";
      }
    } catch (err) {
      alert(`❌ Lỗi kết nối đến máy chủ: ${err.message}`);
      console.error("LỖI:", err);
    }
  });

  async function checkAdminRole(userId, token) {
    try {
      const res = await fetch(`http://localhost:5257/api/Auth/check-admin/${userId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });

      if (!res.ok) {
        console.warn("Kiểm tra admin thất bại:", res.status);
        return false;
      }

      const data = await res.json();
      return data.isAdmin === true; // Giả định API trả về { isAdmin: true/false }
    } catch (err) {
      console.error("Lỗi kiểm tra admin:", err);
      return false;
    }
  }
});