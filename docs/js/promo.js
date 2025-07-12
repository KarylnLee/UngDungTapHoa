let countdownInterval = null;

const flashTimes = [
  { hour: 0, label: "0h - 6h" },
  { hour: 6, label: "6h - 8h" },
  { hour: 8, label: "8h - 10h" },
  { hour: 10, label: "10h - 12h" },
  { hour: 12, label: "12h - 14h" },
  { hour: 14, label: "14h - 16h" },
  { hour: 16, label: "16h - 18h" },
  { hour: 18, label: "18h - 20h" },
  { hour: 20, label: "20h - 22h" },
  { hour: 22, label: "22h - 0h" }
];

// Dữ liệu sản phẩm
const saleProductsData = {
  0: [
    { name: "Ba rọi heo", price: 110000, image: "../assets/promo/baroiheo.jpg", category: "Thịt heo" },
    { name: "Cá hồi phi lê", price: 220000, image: "../assets/promo/cahoi.jpg", category: "Cá hồi" }
  ],
  6: [
    { name: "Rau muống", price: 10000, image: "../assets/promo/raumuong.jpg", category: "Rau lá" },
    { name: "Nấm rơm", price: 25000, image: "../assets/promo/namkimcham.jpg", category: "Nấm các loại" }
  ],
  14: [
    { name: "Dầu gội Clear", price: 89000, image: "../assets/promo/daugoiclear.jpg", category: "Dầu gội" },
    { name: "Sữa tắm Lifebuoy", price: 79000, image: "../assets/promo/SuatamLifebouy.jpg", category: "Sữa tắm" }
  ],
  22: [
    { name: "Nước rửa chén Sunlight", price: 50000, image: "../assets/promo/Nuocruachen.jpg", category: "Nước rửa chén" },
    { name: "Gạo ST25", price: 100000, image: "../assets/promo/GaoST25.jpg", category: "Gạo" }
  ]
};

// Đếm ngược
function updateCountdown(hour) {
  if (countdownInterval) clearInterval(countdownInterval);

  const now = new Date();
  let target;

  if (now.getHours() >= hour && now.getHours() < hour + 2) {
    target = new Date(now.getFullYear(), now.getMonth(), now.getDate(), hour + 2, 0, 0);
  } else if (now.getHours() < hour) {
    target = new Date(now.getFullYear(), now.getMonth(), now.getDate(), hour, 0, 0);
  } else {
    document.getElementById("timer").textContent = "Đã kết thúc";
    return;
  }

  function tick() {
    const now = new Date();
    let diff = Math.max(0, Math.floor((target - now) / 1000));
    const h = String(Math.floor(diff / 3600)).padStart(2, '0');
    const m = String(Math.floor(diff % 3600 / 60)).padStart(2, '0');
    const s = String(diff % 60).padStart(2, '0');
    document.getElementById("timer").textContent = `${h}:${m}:${s}`;

    if (diff <= 0) clearInterval(countdownInterval);
  }

  tick();
  countdownInterval = setInterval(tick, 1000);
}

// Render khung giờ sale
function renderTimeSlots() {
  const container = document.getElementById("timeSlots");
  container.innerHTML = "";
  const nowHour = new Date().getHours();

  flashTimes.forEach((slot) => {
    const div = document.createElement("div");
    div.className = "time-slot";

    let status = "";
    if (nowHour >= slot.hour && nowHour < slot.hour + 2) {
      status = "Đang diễn ra";
      div.classList.add("active");
    } else if (nowHour < slot.hour) {
      status = "Sắp diễn ra";
    } else {
      status = "Đã kết thúc";
      div.classList.add("ended");
    }

    div.innerHTML = `<strong>${slot.label}</strong><br><span>${status}</span>`;

    div.onclick = () => {
      document.querySelectorAll(".time-slot").forEach(el => el.classList.remove("active"));
      div.classList.add("active");
      renderSaleProducts(slot.hour);
      updateCountdown(slot.hour);
    };

    container.appendChild(div);
  });
}

// Render sản phẩm theo khung giờ
function renderSaleProducts(hour) {
  const container = document.getElementById("saleProducts");
  container.innerHTML = "";
  const products = saleProductsData[hour] || [];

  products.forEach(p => {
    const div = document.createElement("div");
    div.className = "sale-product";
    div.innerHTML = `
      <img src="${p.image}" alt="${p.name}">
      <h4>${p.name}</h4>
      <p class="price">${p.price.toLocaleString()}đ</p>
      <button class="add-to-cart-btn">Thêm vào giỏ</button>
    `;

    // Sự kiện thêm vào giỏ
    div.querySelector(".add-to-cart-btn").addEventListener("click", () => {
      addToCart(p);
    });

    container.appendChild(div);
  });
}

// Thêm sản phẩm vào localStorage
function addToCart(product) {
  const cart = JSON.parse(localStorage.getItem("cart")) || [];

  const existing = cart.find(p => p.name === product.name);
  if (existing) {
    existing.quantity += 1;
  } else {
    cart.push({
      name: product.name,
      image: product.image,
      price: product.price,
      quantity: 1,
      selected: true
    });
  }

  localStorage.setItem("cart", JSON.stringify(cart));
  alert("Đã thêm vào giỏ hàng!");
}

// Khởi chạy khi load
function initFlashSale() {
  renderTimeSlots();

  const nowHour = new Date().getHours();
  const currentSlot = flashTimes.find(t => nowHour >= t.hour && nowHour < t.hour + 2)
                      || flashTimes.find(t => t.hour > nowHour)
                      || flashTimes[0];

  renderSaleProducts(currentSlot.hour);
  updateCountdown(currentSlot.hour);
}

document.addEventListener("DOMContentLoaded", initFlashSale);
