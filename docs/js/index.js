import { fetchAllProducts } from './api.js';
import { renderProducts } from './product.js';
import { renderCategoryMenu } from './category.js';

let allProducts = [];
let currentCategoryId = null;

const typingEl = document.getElementById("typing-text");
const text = "Chào mừng đến với ProD Store – Mua sắm tiết kiệm mỗi ngày!";
let index = 0;
let isDeleting = false;

function typeLoop() {
  const speed = isDeleting ? 50 : 100;
  typingEl.textContent = text.substring(0, index);
  if (!isDeleting && index === text.length) {
    setTimeout(() => isDeleting = true, 1500);
  } else if (isDeleting && index === 0) {
    isDeleting = false;
  }
  index += isDeleting ? -1 : 1;
  setTimeout(typeLoop, speed);
}

function updateHeaderForLoggedInUser() {
  const fullName = localStorage.getItem("userFullName");
  const email = localStorage.getItem("userEmail");
  const userDisplayName = fullName || email;
  const header = document.getElementById("headerActions");

  if (userDisplayName) {
    header.innerHTML = `
      <span>👤 Xin chào, ${userDisplayName}</span>
      <button id="btnLogout">Đăng xuất</button>
      <button onclick="location.href='./page/cart.html'">🛒 Giỏ hàng</button>
    `;

    document.getElementById("btnLogout").addEventListener("click", () => {
      localStorage.clear();
      location.reload();
    });
  } else {
    header.innerHTML = `
      <button id="btnLogin" onclick="window.location.href='page/login.html'">Đăng nhập</button>
    `;
  }
}

document.getElementById("priceSort")?.addEventListener("change", (e) => {
  const value = e.target.value;
  let list = [...allProducts];
  if (currentCategoryId)
    list = list.filter(p => p.categoryId === currentCategoryId);
  if (value === "asc") list.sort((a, b) => a.price - b.price);
  else if (value === "desc") list.sort((a, b) => b.price - a.price);
  renderProducts(list);
});

document.getElementById("btnSearch")?.addEventListener("click", () => {
  const keyword = document.getElementById("searchInput").value.trim().toLowerCase();
  const result = allProducts.filter(p => p.name.toLowerCase().includes(keyword));
  renderProducts(result);
});

document.getElementById("searchInput")?.addEventListener("keydown", (e) => {
  if (e.key === "Enter") document.getElementById("btnSearch").click();
});

document.addEventListener("DOMContentLoaded", async () => {
  typeLoop();

  allProducts = await fetchAllProducts();
  renderProducts(allProducts);

  await renderCategoryMenu((categoryId) => {
    currentCategoryId = categoryId;
    const filtered = allProducts.filter(p => p.categoryId === categoryId);
    renderProducts(filtered);
  });

  updateHeaderForLoggedInUser();
});
