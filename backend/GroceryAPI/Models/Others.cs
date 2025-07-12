using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{

    public class RegisterRequest
    {
        public required string FullName { get; set; }
        public required string Email { get; set; }
        public required string PhoneNumber { get; set; }
        public required string Password { get; set; }
        public required string AuthProvider { get; set; }
    }

    public class DeliveryTracking
    {
        [Key]
        public int DeliveryTrackingId { get; set; }

        public int OrderId { get; set; }
        public required string CurrentStatus { get; set; }
        public required string Location { get; set; }
        public DateTime UpdatedAt { get; set; } = DateTime.Now;

        public required Order Order { get; set; }
    }

    public class Coupon
    {
        [Key]
        public int CouponId { get; set; }

        public required string Code { get; set; }
        public decimal DiscountValue { get; set; }
        public DateTime ExpiryDate { get; set; }
        public decimal MinOrderAmount { get; set; }
        public bool IsActive { get; internal set; }
    }

    public class SearchHistory
    {
        [Key]
        public int SearchHistoryId { get; set; }

        public int UserId { get; set; }
        public required string Keyword { get; set; }
        public DateTime SearchedAt { get; set; } = DateTime.Now;
        public User? User { get; set; }
    }

    public class ReturnRequest
    {
        public ReturnRequest()
        {
        }

        [Key]
        public int ReturnRequestId { get; set; }

        public int OrderId { get; set; }
        public required string Reason { get; set; }
        public required string Status { get; set; }
        public DateTime RequestedAt { get; set; } = DateTime.Now;
        public required Order Order { get; set; }
    }
    
    public class Otp
    {
        [Key]
        public int OtpId { get; set; }

        public int UserId { get; set; }
        public string Code { get; set; } = string.Empty;
        public DateTime Expiry { get; set; }
        public string Type { get; set; } = "email"; // email/sms
        public User? User { get; set; }
    }

    public class OtpRequest
    {
        public required string Type { get; set; }
        public required string Code { get; set; }
        public required string Expiry { get; set; }
        public int? UserId { get; set; }
    }


    public class DeliveryChat
    {
        [Key]
        public int ChatId { get; set; }

        public int OrderId { get; set; }
        public string Sender { get; set; } = "user"; // user/shipper
        public string Message { get; set; } = string.Empty;
        public DateTime SentAt { get; set; } = DateTime.Now;
        public Order? Order { get; set; }
    }

    public class QnA
    {
        [Key]
        public int QnAId { get; set; }

        public int ProductId { get; set; }
        public int UserId { get; set; }
        public string Question { get; set; } = string.Empty;
        public string? Answer { get; set; }
        public DateTime AskedAt { get; set; } = DateTime.Now;
        public Product? Product { get; set; }
        public User? User { get; set; }
    }


    public class Admin
    {
        [Key]
        public int AdminId { get; set; }

        public int UserId { get; set; }
        public string Role { get; set; } = "moderator"; // superadmin, moderator
        public User? User { get; set; }
    }

    public class SystemFeedback
    {
        [Key]
        public int FeedbackId { get; set; }

        public int UserId { get; set; }
        public string Message { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public User? User { get; set; }
    }
}