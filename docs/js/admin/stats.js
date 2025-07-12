document.addEventListener("DOMContentLoaded", () => {
  const token = localStorage.getItem("token");
  if (!token) {
    alert("Bạn chưa đăng nhập.");
    window.location.href = "../login.html";
    return;
  }
  const payload = JSON.parse(atob(token.split(".")[1]));
  const role = payload["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
  if (role !== "admin") {
    alert("Bạn không có quyền truy cập trang admin.");
    window.location.href = "../index.html";
  }

  loadStats();
});

async function loadStats() {
  const statsContent = document.getElementById("statsContent");
  const token = localStorage.getItem("token");

  try {
    const res = await fetch("http://localhost:5257/api/Admin/stats", {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (!res.ok) throw new Error("Lỗi khi lấy thống kê");

    const stats = await res.json();
    statsContent.innerHTML = `
      <p>Tổng người dùng: ${stats.totalUsers || 0}</p>
      <p>Tổng đơn hàng: ${stats.totalOrders || 0}</p>
      <p>Doanh thu: ${stats.totalRevenue?.toLocaleString() || 0}đ</p>
    `;
  } catch (err) {
    console.error(err);
    statsContent.innerHTML = "Lỗi khi tải thống kê.";
  }
}