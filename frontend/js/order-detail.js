document.addEventListener("DOMContentLoaded", () => {
  const order = JSON.parse(localStorage.getItem("lastOrder"));
  if (!order) {
    document.body.innerHTML = "<h2>Không tìm thấy đơn hàng!</h2>";
    return;
  }

  const parsePrice = price => typeof price === "number" ? price : Number(price.replace(/[^\d]/g, ""));
  const formatPrice = n => n.toLocaleString("vi-VN") + " đ";

  document.getElementById("order-id").textContent = `Mã đơn hàng: #${order.id}`;
  document.getElementById("order-status").textContent = order.status || "Đang xử lý";
  document.getElementById("order-status").classList.add(
    order.status === "Đã huỷ" ? "canceled" : "delivered"
  );
  document.getElementById("order-date").textContent = order.date;
  document.getElementById("order-payment").textContent = order.payment;
  document.getElementById("order-address").textContent = order.address;

  const tbody = document.getElementById("order-items");
  order.items.forEach(item => {
    const price = parsePrice(item.price);
    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${item.name}</td>
      <td>${item.quantity}</td>
      <td>${formatPrice(price)}</td>
      <td>${formatPrice(item.quantity * price)}</td>
    `;
    tbody.appendChild(row);
  });

  const summary = document.getElementById("order-summary");
  summary.innerHTML = `
    <p>Phí vận chuyển: <strong>${formatPrice(order.shippingFee)}</strong></p>
    <p>Giảm giá: <strong>-${formatPrice(order.discount)}</strong></p>
    <p class="total">Tổng thanh toán: <strong>${formatPrice(order.total)}</strong></p>
  `;

  document.querySelector(".reorder-btn").addEventListener("click", () => {
    localStorage.setItem("cart", JSON.stringify(order.items));
    window.location.href = "checkout.html";
  });
});
