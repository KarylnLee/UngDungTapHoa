using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using Microsoft.AspNetCore.Authorization;
using System.Buffers.Text;



namespace GroceryAPI.Controllers
{
    
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class CartController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;

        public CartController(AppDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        [HttpGet("{userId}")]
        public async Task<IActionResult> GetCart(int userId)
        {
            var baseUrl = _configuration["AppSettings:BaseUrl"];
            var cartItems = await _context.CartItems
                .Include(c => c.Product)
                .Where(c => c.UserId == userId)
                
                .Select(c => new
                {
                    c.CartItemId,
                    c.ProductId,
                    c.Quantity,
                    c.IsSelected,
                    Product = c.Product == null ? null : new
                        {
                             c.Product.Name,
                                c.Product.Price,
                                ImageUrl = !string.IsNullOrEmpty(c.Product.ImageURL) && c.Product.ImageURL.StartsWith("http")
                                    ? c.Product.ImageURL
                                    : baseUrl + c.Product.ImageURL
                        }

                })
                .ToListAsync();

            return Ok(cartItems);
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddToCart([FromBody] CartItem item)
        {
            var cartCount = await _context.CartItems.CountAsync(c => c.UserId == item.UserId);
            if (cartCount >= 100) return BadRequest("Giỏ hàng đã đạt giới hạn 100 sản phẩm.");

            var existing = await _context.CartItems.FirstOrDefaultAsync(c => c.UserId == item.UserId && c.ProductId == item.ProductId);
            if (existing != null) existing.Quantity += item.Quantity;
            else _context.CartItems.Add(item);
            await _context.SaveChangesAsync();
            return Ok("Thêm vào giỏ hàng thành công");
        }

        [HttpPut("update")]
        public async Task<IActionResult> UpdateQuantity([FromBody] CartItem item)
        {
            var cartItem = await _context.CartItems.FindAsync(item.CartItemId);
            if (cartItem == null) return NotFound();
            cartItem.Quantity = item.Quantity;
            cartItem.IsSelected = item.IsSelected;
            await _context.SaveChangesAsync();
            return Ok("Cập nhật thành công");
        }

        [HttpDelete("remove/{id}")]
        public async Task<IActionResult> Remove(int id)
        {
            var cartItem = await _context.CartItems.FindAsync(id);
            if (cartItem == null) return NotFound();
            _context.CartItems.Remove(cartItem);
            await _context.SaveChangesAsync();
            return Ok("Đã xóa sản phẩm khỏi giỏ hàng");
        }

        [HttpGet("total/{userId}")]
            public async Task<IActionResult> GetCartTotal(int userId)
            {
                var total = await _context.CartItems
                    .Where(c => c.UserId == userId && c.IsSelected && c.Product != null)
                    .SumAsync(c => c.Quantity * (c.Product != null ? c.Product.Price : 0));
                return Ok(new { totalAmount = total });
            }

    }
}