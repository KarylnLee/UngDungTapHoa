using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{
    public class Review
    {
        [Key]
        public int ReviewId { get; set; }
        
        public int ProductId { get; set; }
        public int UserId { get; set; }

        [Range(1, 5, ErrorMessage = "Rating phải từ 1 đến 5")]
        public int Rating { get; set; }

        [Required]
        public required string Comment { get; set; }
        public required string ImageURL { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}