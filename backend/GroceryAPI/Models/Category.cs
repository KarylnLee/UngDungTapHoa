using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{
    public class Category
    {
        [Key]
        public int CategoryId { get; set; }
        
        public required string Name { get; set; }
        public string? IconUrl { get; set; }
        public required ICollection<Product> Products { get; set; }
    }
}