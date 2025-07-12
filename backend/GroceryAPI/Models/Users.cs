using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{
    public class User
    {
        [Key]
        public int UserId { get; set; }
        
        [Required, EmailAddress]
        public required string Email { get; set; }

        [Required]
        public required string PasswordHash { get; set; }
        public required string FullName { get; set; }

        [Required, Phone]
        public required string PhoneNumber { get; set; }
        public required string AuthProvider { get; set; } // local, google, facebook
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public bool IsActive { get; set; } = true; // Trạng thái người dùng
    }
}