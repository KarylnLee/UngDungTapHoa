using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace GroceryAPI.Models
{
    public class CartItem
    {
        [Key]
        public int CartItemId { get; set; }
        
        [Required]
        public int UserId { get; set; }

        [Required]
        public int ProductId { get; set; }

        [Range(1, int.MaxValue)]
        public int Quantity { get; set; }
        public bool IsSelected { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [JsonIgnore]
        public User? User { get; set; }

        [JsonIgnore]
        public Product? Product { get; set; }
    }
}