const baseUrl = "http://localhost:5257";

// HÀM HIỂN THỊ SẢN PHẨM
export function renderProducts(products, containerId = "productGrid") {
  const container = document.getElementById(containerId);
  container.innerHTML = "";

  if (!products.length) {
    container.innerHTML = "<p>Không có sản phẩm phù hợp.</p>";
    return;
  }

  products.forEach(p => {
    const unit = p.unit || "kg";
    const card = document.createElement("div");
    card.className = "product";

    card.innerHTML = `
      <img src="${p.imageURL}" alt="${p.name}">
      <h4>${p.name}</h4>
      <p>Giá: ${Number(p.price).toLocaleString()}đ/${unit}</p>
      <div class="product-buttons">
        <button class="btn btn-buy" onclick="location.href='./page/cart.html'">Mua</button>
        <button class="btn btn-cart">🛒</button>
      </div>
      <a href="./page/product-detail.html?name=${encodeURIComponent(p.name)}&image=${encodeURIComponent(p.imageURL)}&price=${p.price}&desc=${encodeURIComponent(p.description)}&unit=${encodeURIComponent(unit)}"
         class="btn">Xem chi tiết</a>
    `;

    // GẮN SỰ KIỆN THÊM VÀO GIỎ HÀNG
    card.querySelector(".btn-cart").addEventListener("click", () => {
      addToCart(p);
    });

    container.appendChild(card);
  });
}

// HÀM THÊM SẢN PHẨM VÀO GIỎ HÀNG
async function addToCart(product) {
  const token = localStorage.getItem("token");
  const userId = localStorage.getItem("userId");

  if (!token || !userId) {
    alert("Vui lòng đăng nhập để thêm sản phẩm vào giỏ.");
    window.location.href = "login.html";
    return;
  }

  try {
    const res = await fetch(`${baseUrl}/api/cart/add`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        userId: Number(userId),
        productId: product.id || product.productId,  // xử lý cả hai kiểu
        quantity: 1
      })
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(text);
    }

    alert(`✅ Đã thêm "${product.name}" vào giỏ hàng!`);

    // Option: Sau khi thêm thì load lại giỏ hàng để lưu vào localStorage nếu muốn hiển thị ngay
    if (typeof loadCartFromDB === "function") {
      await loadCartFromDB(userId, token); // nếu đã định nghĩa từ trước
    }

  } catch (err) {
    console.error("Lỗi thêm vào giỏ hàng:", err);
    alert("❌ Thêm giỏ hàng thất bại: " + err.message);
  }
}
