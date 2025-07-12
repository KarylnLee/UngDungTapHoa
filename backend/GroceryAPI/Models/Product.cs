using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{
    public class Product
    {
        [Key]
        public int ProductId { get; set; }
        
        public required string Name { get; set; }
        public int CategoryId { get; set; }
        public required string Brand { get; set; }
        public required string Description { get; set; }
        public required string Unit { get; set; }
        public int Stock { get; set; }
        public decimal Price { get; set; }
        public required string ImageURL { get; set; }
        public required string Ingredients { get; set; } // Thành phần sản phẩm
        public float RatingAvg { get; set; } = 0;

        public required Category Category { get; set; }
    }
}
