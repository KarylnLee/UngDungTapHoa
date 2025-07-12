using Microsoft.EntityFrameworkCore;
using GroceryAPI.Models;

namespace GroceryAPI.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<ShippingAddress> ShippingAddresses { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<CartItem> CartItems { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderDetail> OrderDetails { get; set; }
        public DbSet<Review> Reviews { get; set; }
        public DbSet<DeliveryTracking> DeliveryTracking { get; set; }
        public DbSet<Coupon> Coupons { get; set; }
        public DbSet<SearchHistory> SearchHistories { get; set; }
        public DbSet<ReturnRequest> ReturnRequests { get; set; }
        public DbSet<Otp> Otps { get; set; }
        public DbSet<DeliveryChat> DeliveryChats { get; set; }
        public DbSet<QnA> QnAs { get; set; }
        public DbSet<Admin> Admins { get; set; }
        public DbSet<SystemFeedback> SystemFeedbacks { get; set; }
    }
}