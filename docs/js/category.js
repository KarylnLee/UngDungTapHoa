
window.categoryGroups = [
  {
    group: "THỊT, CÁ, TRỨNG, HẢI SẢN",
    children: [
      { id: 1, name: "Thịt heo" },
      { id: 2, name: "Thịt bò" },
      { id: 3, name: "Thịt gà, vịt,..." },
      { id: 4, name: "Cá Hồi" },
      { id: 5, name: "Hải sản" },
      { id: 6, name: "Trứng gà, vịt, cút" }
    ]
  },
  {
    group: "RAU, CỦ, NẤM, TRÁI CÂY",
    children: [
      { id: 7, name: "Trái cây" },
      { id: 8, name: "Rau lá" },
      { id: 9, name: "Củ, quả" },
      { id: 10, name: "Nấm các loại" },
      { id: 11, name: "Rau, củ làm sẵn" }
    ]
  },

  {
    group: "CHĂM SÓC CÁ NHÂN",
    children: [
      { id: 12, name: "Dầu gội" },
      { id: 13, name: "Sữa tắm" },
      { id: 14, name: "Kem đánh răng" },
      { id: 15, name: "Bàn chải, tăm chỉ nha khoa" },
      { id: 16, name: "Giấy vệ sinh" },
      { id: 17, name: "Dầu xả, kem ủ" },
      { id: 18, name: "Băng vệ sinh" },
      { id: 19, name: "Dao cạo, bọt cạo râu" }
    ]
  },

  {
    group: "GIA DỤNG",
    children: [
      { id: 20, name: "Túi rác" },
      { id: 21, name: "Nồi, chảo" },
      { id: 22, name: "Dụng cụ bếp" },
      { id: 23, name: "Quạt" },
      { id: 24, name: "Cây lau nhà, quét nhà" }
    ]
  },

  {
    group: "VỆ SINH NHÀ CỬA",
    children: [
      { id: 25, name: "Nước rửa chén" },
      { id: 26, name: "Nước lau nhà" },
      { id: 27, name: "Nước giặt, bột giặt" },
      { id: 28, name: "Nước xả" },
      { id: 29, name: "Nước tẩy" }
    ]
  },

  {
    group: "GẠO, BỘT, ĐỒ KHÔ",
    children: [
      { id: 30, name: "Gạo, nếp các loại" },
      { id: 31, name: "Xúc xích" },
      { id: 32, name: "Bột các loại" },
      { id: 33, name: "Nước cốt dừa, ngũ cốc" },
      { id: 34, name: "Rong biển" }
    ]
  },

  {
    group: "GIA VỊ, NƯỚC NẰM",
    children: [
      { id: 35, name: "Dầu ăn" },
      { id: 36, name: "Nước mắm" },
      { id: 37, name: "Nước tương" },
      { id: 38, name: "Muối" },
      { id: 39, name: "Tiêu, sa tế, ớt bột,.." },
      { id: 40, name: "Hạt nêm, bột ngọt, bột canh,.." }
    ]
  },

  {
    group: "BÁNH, KẸO, SỮA, NƯỚC",
    children: [
      { id: 41, name: "Snack các loại" },
      { id: 42, name: "Kẹo các loại" },
      { id: 43, name: "Sữa các loại" },
      { id: 44, name: "Trái cây sấy" },
      { id: 45, name: "Nước các loại" }
    ]
  }

];
export function renderCategoryMenu(onCategoryClick) {
  const list = document.getElementById("categoryList");
  list.innerHTML = "";

  categoryGroups.forEach(group => {
    const li = document.createElement("li");
    li.className = "menu-item";

    li.innerHTML = `
      <button class="menu-title collapsible" aria-expanded="false">
        ${group.group} <span class="arrow"></span>
      </button>
      <ul class="submenu" style="display:none">
        ${group.children.map(child => `
          <li><a href="#" data-id="${child.id}">${child.name}</a></li>
        `).join("")}
      </ul>
    `;
    list.appendChild(li);
  });

  // Collapse toggle
  document.querySelectorAll(".menu-title").forEach(button => {
    button.addEventListener("click", () => {
      const expanded = button.getAttribute("aria-expanded") === "true";
      button.setAttribute("aria-expanded", !expanded);
      const submenu = button.nextElementSibling;
      submenu.style.display = expanded ? "none" : "block";
    });
  });

  // Click vào từng danh mục con
  list.querySelectorAll("a[data-id]").forEach(link => {
    link.addEventListener("click", (e) => {
      e.preventDefault();
      const categoryId = parseInt(e.target.dataset.id);
      if (onCategoryClick) onCategoryClick(categoryId);
    });
  });
}