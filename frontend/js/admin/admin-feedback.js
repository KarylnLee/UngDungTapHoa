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

  loadFeedbacks();
});

async function loadFeedbacks() {
  const tbody = document.querySelector("#feedbackTable tbody");
  const token = localStorage.getItem("token");

  try {
    const res = await fetch("http://localhost:5257/api/Admin/feedbacks", {
      headers: { Authorization: `Bearer ${token}` },
    });

    if (!res.ok) throw new Error("Lỗi khi lấy phản hồi");

    const feedbacks = await res.json();
    tbody.innerHTML = "";

    feedbacks.forEach((feedback) => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td>${feedback.feedbackId || "N/A"}</td>
        <td>${feedback.user?.fullName || "Ẩn"}</td>
        <td>${feedback.content || "Chưa có"}</td>
        <td>${new Date(feedback.createdAt).toLocaleDateString("vi-VN")}</td>
      `;
      tbody.appendChild(tr);
    });
  } catch (err) {
    console.error(err);
    alert("Lỗi khi tải phản hồi.");
  }
}