using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;


namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class OrderController : ControllerBase
    {
        private readonly AppDbContext _context;
        public OrderController(AppDbContext context) { _context = context; }

        [HttpPost("create")]
        public async Task<IActionResult> CreateOrder([FromBody] CreateOrderDto dto)
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdStr) || !int.TryParse(userIdStr, out int userId))
            {
                return Unauthorized("Token không hợp lệ hoặc thiếu thông tin.");
            }

            var userEntity = await _context.Users.FindAsync(userId);
            if (userEntity == null)
                return Unauthorized("Không tìm thấy thông tin người dùng.");

            var address = await _context.ShippingAddresses.FindAsync(dto.AddressId);
            if (address == null || address.UserId != userId)
                return NotFound("Địa chỉ giao hàng không hợp lệ.");

            if (dto.OrderItems == null || !dto.OrderItems.Any())
                return BadRequest("Không có sản phẩm nào trong đơn hàng.");

            var totalAmount = dto.OrderItems.Sum(c => c.Quantity * c.UnitPrice);

#pragma warning disable CS8601 // Possible null reference assignment.
            var order = new Order
            {
                UserId = userId,
                User = userEntity,
                AddressId = dto.AddressId,
                Address = address,
                ShippingMethod = dto.ShippingMethod,
                ShippingFee = dto.ShippingFee,
                TotalAmount = totalAmount,
                Status = "pending",
                PaymentMethod = dto.PaymentMethod
            };
#pragma warning restore CS8601 // Possible null reference assignment.

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            foreach (var item in dto.OrderItems)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                if (product == null) continue;

                _context.OrderDetails.Add(new OrderDetail
                {
                    OrderId = order.OrderId,
                    Order = order,
                    ProductId = item.ProductId,
                    Product = product,
                    Quantity = item.Quantity,
                    UnitPrice = item.UnitPrice
                });
            }

            await _context.SaveChangesAsync();
            return Ok(new { orderId = order.OrderId, message = "Đặt hàng thành công" });
        }

        [HttpPost("addresses/add")]
        public async Task<IActionResult> AddAddress([FromBody] ShippingAddress address)
        {
            var userIdStr = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdStr) || !int.TryParse(userIdStr, out int userId))
                return Unauthorized("Token không hợp lệ");

            address.UserId = userId;
            _context.ShippingAddresses.Add(address);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Đã thêm địa chỉ thành công", addressId = address.AddressId });
        }

        [HttpGet("addresses/{userId}")]
        public async Task<IActionResult> GetUserAddresses(int userId)
        {
            var addresses = await _context.ShippingAddresses
                .Where(a => a.UserId == userId)
                .ToListAsync();

            return Ok(addresses);
        }


        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserOrders(int userId)
        {
            return Ok(await _context.Orders
                .Where(o => o.UserId == userId)
                .ToListAsync());
        }
    }


    public class CreateOrderDto
    {
        public int AddressId { get; set; }
        public required string ShippingMethod { get; set; }
        public decimal ShippingFee { get; set; }
        public required string PaymentMethod { get; set; }
        public List<OrderItemDto> OrderItems { get; set; } = new();
        public string? ShippingAddressText { get; internal set; }
    }

    public class OrderItemDto
    {
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }
}
