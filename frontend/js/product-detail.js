const urlParams = new URLSearchParams(window.location.search);
const name = urlParams.get("name");
const imageURL = urlParams.get("imageURL");
const price = urlParams.get("price");
const desc = urlParams.get("desc");
const unit = urlParams.get("unit") || "kg";

document.addEventListener('DOMContentLoaded', () => {
  if (name) document.getElementById("productName").textContent = name;
  if (imageURL) {
    const img = document.getElementById("productImage");
    img.src = "http://localhost:5257/" + imageURL;
    img.alt = name || "Sản phẩm";
  }
  if (desc) document.getElementById("productDesc").textContent = desc;
  if (price) {
    document.getElementById("productPrice").textContent = `Giá: ${Number(price).toLocaleString()}đ/${unit}`;
  }
});
