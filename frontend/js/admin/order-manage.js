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

  loadOrders();
});

async function loadOrders() {
  const token = localStorage.getItem("token");
  const tbody = document.querySelector("#orderTable tbody");

  if (!token) return alert("Bạn chưa đăng nhập.");

  try {
    const res = await fetch("http://localhost:5257/api/Order/user/1", { // Cần API admin tương tự
      headers: { Authorization: `Bearer ${token}` },
    });

    if (!res.ok) throw new Error("Lỗi khi lấy đơn hàng");

    const orders = await res.json();
    tbody.innerHTML = "";

    orders.forEach((order) => {
      const tr = document.createElement("tr");
      tr.innerHTML = `
        <td>${order.orderId}</td>
        <td>${order.user?.fullName || "Ẩn"}</td>
        <td>${new Date(order.createdAt).toLocaleDateString("vi-VN")}</td>
        <td>${order.paymentMethod}</td>
        <td>
          <select data-id="${order.orderId}" class="status-select">
            <option value="pending" ${order.status === "pending" ? "selected" : ""}>Chờ xử lý</option>
            <option value="delivering" ${order.status === "delivering" ? "selected" : ""}>Đang giao</option>
            <option value="completed" ${order.status === "completed" ? "selected" : ""}>Hoàn tất</option>
            <option value="cancelled" ${order.status === "cancelled" ? "selected" : ""}>Hủy</option>
          </select>
        </td>
        <td>${order.totalAmount.toLocaleString()}đ</td>
        <td><button data-id="${order.orderId}" class="view-detail">Xem</button></td>
      `;
      tbody.appendChild(tr);
    });

    document.querySelectorAll(".view-detail").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const orderId = btn.dataset.id;
        const detailRes = await fetch(`http://localhost:5257/api/Order/user/1/${orderId}`, {
          headers: { Authorization: `Bearer ${token}` },
        });

        const data = await detailRes.json();

        const detailRow = document.createElement("tr");
        detailRow.className = "detail-row";
        detailRow.innerHTML = `
          <td colspan="7">
            <b>Chi tiết:</b><br/>
            ${data.items.map(i => `${i.productName} x ${i.quantity} = ${i.unitPrice * i.quantity}đ`).join("<br/>")}
          </td>
        `;
        btn.closest("tr").after(detailRow);
        btn.disabled = true;
      });
    });

    document.querySelectorAll(".status-select").forEach((select) => {
      select.addEventListener("change", async () => {
        const orderId = select.dataset.id;
        const newStatus = select.value;

        await fetch(`http://localhost:5257/api/Admin/update-order-status/${orderId}`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify({ status: newStatus }),
        });

        alert("✅ Cập nhật trạng thái đơn hàng!");
      });
    });

  } catch (err) {
    console.error(err);
    alert("Lỗi khi tải đơn hàng.");
  }
}