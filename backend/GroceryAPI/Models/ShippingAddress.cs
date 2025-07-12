using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{
    public class ShippingAddress
    {
        [Key]
        public int AddressId { get; set; }
        
        public int UserId { get; set; }
        public required string FullAddress { get; set; }
        public bool IsDefault { get; set; } = false;

        public required User User { get; set; }
    }
}