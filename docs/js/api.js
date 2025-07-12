const BASE_URL = "http://localhost:5257";

export async function fetchAllProducts() {
  const res = await fetch(`${BASE_URL}/api/Product/all`);
  return res.json();
}

export async function fetchAllCategories() {
  const res = await fetch(`${BASE_URL}/api/Category/all`);
  return res.json();
}
