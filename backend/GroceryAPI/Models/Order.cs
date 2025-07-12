using System.ComponentModel.DataAnnotations;

namespace GroceryAPI.Models
{
    public class Order
    {
        [Key]
        public int OrderId { get; set; }
        
        public int UserId { get; set; }
        public int AddressId { get; set; }  // Đổi tên này
        public required string ShippingMethod { get; set; }
        public decimal ShippingFee { get; set; }
        public decimal TotalAmount { get; set; }
        public required string Status { get; set; }
        public required string PaymentMethod { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public int? DeliveryRating { get; set; } // Đánh giá đơn hàng (1-5)

        public required User User { get; set; }
        public required ShippingAddress Address { get; set; }
        public List<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
    }

    public class OrderDetail
    {
        public OrderDetail()
        {
        }

        public int OrderDetailId { get; set; }
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }

        public required Order Order { get; set; }
        public required Product Product { get; set; }
    }
}