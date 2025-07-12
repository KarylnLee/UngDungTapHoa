async function loadAddresses() {
  const token = localStorage.getItem("token");
  const userId = localStorage.getItem("userId");

  const res = await fetch(`http://localhost:5257/api/order/addresses/${userId}`, {
    headers: { Authorization: `Bearer ${token}` }
  });

  if (!res.ok) {
    alert("Không thể tải địa chỉ giao hàng.");
    return;
  }

  const data = await res.json();
  const select = document.getElementById("addressSelect");

  data.forEach(addr => {
    const opt = document.createElement("option");
    opt.value = addr.addressId;
    opt.textContent = addr.fullAddress;
    select.appendChild(opt);
  });
}

document.addEventListener("DOMContentLoaded", function () {
  const orderSummary = document.querySelector(".order-summary");
  const applyBtn = document.querySelector(".apply-btn");
  const discountInput = document.querySelector("input[placeholder='Nhập mã giảm giá']");
  const placeOrderBtn = document.querySelector(".place-order-btn");

  loadAddresses();

  let allCartItems = JSON.parse(localStorage.getItem("cart")) || [];
  let orderItems = allCartItems.filter(item => item.selected);
  const token = localStorage.getItem("token");

  if (!token) {
    alert("Vui lòng đăng nhập để đặt hàng.");
    window.location.href = "login.html";
    return;
  }

  if (orderItems.length === 0) {
    document.querySelector(".checkout-right").innerHTML = "<p>🛒 Giỏ hàng trống hoặc chưa chọn sản phẩm. Vui lòng quay lại trang sản phẩm.</p>";
    return;
  }

  let shippingFee = 20000;
  let discount = 0;

  function formatPrice(n) {
    return n.toLocaleString("vi-VN") + " đ";
  }

  function calcTotal() {
    const subtotal = orderItems.reduce((sum, item) => sum + item.price * item.quantity, 0);
    return subtotal + shippingFee - discount;
  }

  function renderSummary() {
    orderSummary.innerHTML = "";
    let subtotal = 0;

    orderItems.forEach(item => {
      subtotal += item.quantity * item.price;
      orderSummary.innerHTML += `<li>${item.name} - ${item.quantity} x ${formatPrice(item.price)}</li>`;
    });

    orderSummary.innerHTML += `<li>Phí vận chuyển: <strong>${formatPrice(shippingFee)}</strong></li>`;
    if (discount > 0) {
      orderSummary.innerHTML += `<li>Mã giảm giá: <strong>- ${formatPrice(discount)}</strong></li>`;
    }

    orderSummary.innerHTML += `<li><strong>Tổng thanh toán: ${formatPrice(calcTotal())}</strong></li>`;
  }

  applyBtn.addEventListener("click", function () {
    const code = discountInput.value.trim().toUpperCase();
    if (code === "GIAM10K") {
      discount = 10000;
      alert("✅ Mã giảm giá đã được áp dụng!");
    } else {
      discount = 0;
      alert("❌ Mã không hợp lệ.");
    }
    renderSummary();
  });

  placeOrderBtn.addEventListener("click", async function () {
    const paymentMethodSelect = document.getElementById("paymentSelect");
    const addressSelect = document.getElementById("addressSelect");

    if (!paymentMethodSelect || !addressSelect) {
      alert("❌ Vui lòng chọn phương thức thanh toán và địa chỉ giao hàng.");
      return;
    }

    
      const paymentMethod = paymentMethodSelect.value;
      const addressIdRaw = addressSelect.value;
      const addressId = parseInt(addressIdRaw);

      console.log("👉 addressSelect.value =", addressIdRaw);
      console.log("👉 parseInt(addressIdRaw) =", addressId);    

      if (isNaN(addressId) || addressId === 0) {
        alert("❌ Vui lòng chọn địa chỉ giao hàng.");
        return;
      }

    const orderItemsDto = orderItems.map(item => ({
      ProductId: item.id,
      Quantity: item.quantity,
      UnitPrice: item.price
    }));

    try {
      const response = await fetch("http://localhost:5257/api/order/create", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`
        },
        body: JSON.stringify({
        addressId: addressId,
        shippingMethod: "Giao hàng tiêu chuẩn",
        shippingFee: shippingFee,
        paymentMethod: paymentMethod,
        orderItems: orderItemsDto,
        shippingAddressText: addressSelect.options[addressSelect.selectedIndex].text
      })
      });

      if (!response.ok) {
        const error = await response.text();
        throw new Error(error || "Lỗi đặt hàng.");
      }

      const result = await response.json();
      alert("🎉 Đặt hàng thành công!");

      // Xóa sản phẩm đã đặt
      allCartItems = allCartItems.filter(p => !p.selected);
      localStorage.setItem("cart", JSON.stringify(allCartItems));

      window.location.href = "order-detail.html";
    } catch (err) {
      alert("❌ " + err.message);
    }
  });

  renderSummary();
});
