document.addEventListener("DOMContentLoaded", () => {
  // Kiểm tra quyền truy cập
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

  loadUsers();
});

async function loadUsers() {
  const tableBody = document.querySelector("#userTable tbody");
  const searchInput = document.getElementById("searchInput");
  let users = [];

  const token = localStorage.getItem("token");

  try {
    const res = await fetch("http://localhost:5257/api/Admin/users", {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (!res.ok) {
      if (res.status === 401) {
        alert("Bạn không có quyền truy cập. Vui lòng đăng nhập lại.");
        window.location.href = "../login.html";
      } else {
        throw new Error(`Lỗi HTTP ${res.status}`);
      }
      return;
    }

    users = await res.json();
    render(users);
  } catch (err) {
    alert("Không thể tải danh sách người dùng.\n" + err);
    console.error(err);
  }

  function render(data) {
    tableBody.innerHTML = "";
    data.forEach((u) => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td>${u.userId}</td>
        <td>${u.fullName}</td>
        <td>${u.email}</td>
        <td>${u.phoneNumber}</td>
        <td>${new Date(u.createdAt).toLocaleDateString("vi-VN")}</td>
      `;
      tableBody.appendChild(tr);
    });
  }

  searchInput.addEventListener("input", () => {
    const keyword = searchInput.value.toLowerCase();
    const filtered = users.filter(
      (u) =>
        u.fullName.toLowerCase().includes(keyword) ||
        u.email.toLowerCase().includes(keyword)
    );
    render(filtered);
  });
}