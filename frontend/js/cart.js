document.addEventListener("DOMContentLoaded", async function () {
  const token = localStorage.getItem("token");
  const userId = localStorage.getItem("userId");
  const baseUrl = "http://localhost:5257";

  if (!token || !userId) {
    alert("Vui lòng đăng nhập để xem giỏ hàng.");
    window.location.href = "login.html";
    return;
  }

  function formatPrice(n) {
    return n.toLocaleString("vi-VN") + " đ";
  }

  function parsePrice(priceStr) {
    if (typeof priceStr === "number") return priceStr;
    return Number(priceStr.toString().replace(/[^\d]/g, "")) || 0;
  }

  // Load giỏ hàng từ backend
  async function loadCartFromDB(userId, token) {
    try {
      const res = await fetch(`${baseUrl}/api/cart/${userId}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      if (!res.ok) throw new Error("Không thể tải giỏ hàng từ server.");
      const cartItems = await res.json();
      console.log("Cart items from API:", cartItems)

      const formattedCart = cartItems.map(ci => {
        const product = ci.product || {};
        const imageUrl = product.imageUrl || product.ImageURL || "";
        return {
          cartItemId: ci.cartItemId,
          id: ci.productId,
          name: product.name || "Sản phẩm không xác định",
          price: product.price || 0,
          image: imageUrl
            ? (imageUrl.startsWith("http") ? imageUrl : baseUrl + imageUrl)
            : `${baseUrl}/images/default-product.png`,
          quantity: ci.quantity,
          selected: ci.isSelected
        };
      });

      localStorage.setItem("cart", JSON.stringify(formattedCart));
      renderCartFromStorage();
    } catch (err) {
      console.error("Lỗi loadCartFromDB:", err);
      alert("Lỗi khi tải giỏ hàng: " + err.message);
      renderCartFromStorage();
    }
  }

  // Render giỏ hàng
  function renderCartFromStorage() {
    const cart = JSON.parse(localStorage.getItem("cart")) || [];
    const cartContainer = document.getElementById("cartItems");
    const tbody = document.getElementById("cart-body");
    tbody.innerHTML = "";

    cart.forEach((item, index) => {
      const subtotal = parsePrice(item.price) * item.quantity;
      const row = document.createElement("tr");
      row.innerHTML = `
        <td><input type="checkbox" class="item-check" data-index="${index}" ${item.selected ? "checked" : ""} /></td>
        <td class="product-info">
          <img src="${item.image}" alt="${item.name}" style="width:60px; height:60px; object-fit:cover;"/>
          <span>${item.name}</span>
        </td>
        <td>${formatPrice(parsePrice(item.price))}</td>
        <td><input type="number" value="${item.quantity}" min="1" class="quantity-input" data-index="${index}" /></td>
        <td class="subtotal">${formatPrice(subtotal)}</td>
        <td><button class="remove-btn" data-index="${index}">X</button></td>
      `;
      tbody.appendChild(row);
    });

    bindCartEvents();
    updateTotal();
  }

  // Cập nhật CartItem lên DB
  async function updateCartItemInDB(item) {
    try {
      await fetch(`${baseUrl}/api/cart/update`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
          CartItemId: item.cartItemId,
          Quantity: item.quantity,
          IsSelected: item.selected
        })
      });
    } catch (err) {
      console.error("Lỗi cập nhật giỏ hàng:", err);
    }
  }

  // Xóa CartItem DB
  async function removeCartItemInDB(cartItemId) {
    try {
      await fetch(`${baseUrl}/api/cart/remove/${cartItemId}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` }
      });
    } catch (err) {
      console.error("Lỗi xóa sản phẩm giỏ hàng:", err);
    }
  }

  // Gán sự kiện cho các phần tử giỏ hàng
  function bindCartEvents() {
    const cart = JSON.parse(localStorage.getItem("cart")) || [];

    // Thay đổi số lượng
    document.querySelectorAll(".quantity-input").forEach(input => {
      input.addEventListener("input", async function () {
        const index = input.dataset.index;
        let newQty = parseInt(input.value);
        if (isNaN(newQty) || newQty < 1) {
          newQty = 1;
          input.value = 1;
        }
        cart[index].quantity = newQty;
        localStorage.setItem("cart", JSON.stringify(cart));
        await updateCartItemInDB(cart[index]);
        renderCartFromStorage();
      });
    });

    // Xóa sản phẩm
    document.querySelectorAll(".remove-btn").forEach(btn => {
      btn.addEventListener("click", async function () {
        const index = btn.dataset.index;
        if (confirm(`Xóa "${cart[index].name}" khỏi giỏ hàng?`)) {
          await removeCartItemInDB(cart[index].cartItemId);
          cart.splice(index, 1);
          localStorage.setItem("cart", JSON.stringify(cart));
          renderCartFromStorage();
        }
      });
    });

    // Chọn sản phẩm
    document.querySelectorAll(".item-check").forEach(box => {
      box.addEventListener("change", async function () {
        const index = box.dataset.index;
        cart[index].selected = box.checked;
        localStorage.setItem("cart", JSON.stringify(cart));
        await updateCartItemInDB(cart[index]);
        updateTotal();
      });
    });

    // Nút thanh toán
    document.querySelector(".checkout-btn").addEventListener("click", function () {
      const selectedItems = cart.filter(item => item.selected);
      if (selectedItems.length === 0) {
        alert("Vui lòng chọn ít nhất một sản phẩm để thanh toán.");
        return;
      }
      localStorage.setItem("checkoutItems", JSON.stringify(selectedItems));
      window.location.href = "checkout.html"; // chuyển sang trang thanh toán
    });
  }

  // Tính tổng tiền
  function updateTotal() {
    const cart = JSON.parse(localStorage.getItem("cart")) || [];
    let total = 0;
    let totalQuantity = 0;

    document.querySelectorAll("#cart-body tr").forEach((row, i) => {
      const checkbox = row.querySelector(".item-check");
      const quantity = parseInt(row.querySelector(".quantity-input").value);
      const price = parsePrice(cart[i].price);
      const subtotal = price * quantity;

      row.querySelector(".subtotal").textContent = formatPrice(subtotal);

      if (checkbox.checked) {
        total += subtotal;
        totalQuantity += quantity;
      }
    });

    document.getElementById("total-price").textContent = formatPrice(total);
    const warningEl = document.querySelector(".warning");
    if (warningEl) warningEl.style.display = totalQuantity > 100 ? "block" : "none";
  }

  // Load giỏ hàng lần đầu
  await loadCartFromDB(userId, token);
});
