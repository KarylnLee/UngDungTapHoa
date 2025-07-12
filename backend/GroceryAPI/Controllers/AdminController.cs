using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using GroceryAPI.Data;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "admin")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;
        public AdminController(AppDbContext context) { _context = context; }

        [HttpGet("users")]
        public async Task<IActionResult> GetUsers() => Ok(await _context.Users.ToListAsync());

        [HttpGet("stats")]
        public async Task<IActionResult> GetStatistics()
        {
            var orders = await _context.Orders.ToListAsync();
            var revenue = orders.Sum(o => o.TotalAmount);
            var totalUsers = await _context.Users.CountAsync();
            var topProducts = await _context.OrderDetails
                .GroupBy(x => x.ProductId)
                .Select(g => new { ProductId = g.Key, Quantity = g.Sum(x => x.Quantity) })
                .OrderByDescending(g => g.Quantity)
                .Take(5).ToListAsync();

            return Ok(new { totalUsers, revenue, topProducts });
        }

        [HttpPut("user/update/{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] User user)
        {
            var existing = await _context.Users.FindAsync(id);
            if (existing == null) return NotFound();
            existing.FullName = user.FullName;
            existing.PhoneNumber = user.PhoneNumber;
            existing.IsActive = user.IsActive;
            await _context.SaveChangesAsync();
            return Ok("Cập nhật người dùng thành công");
        }

        [HttpGet("orders")]
        [Authorize(Roles = "admin")]
        public async Task<IActionResult> GetOrders()
        {
            var orders = await _context.Orders.ToListAsync();
            return Ok(orders);
        }

        [HttpDelete("user/delete/{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();
            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return Ok("Xóa người dùng thành công");
        }

        [HttpGet("feedbacks")]
        public async Task<IActionResult> GetFeedbacks()
        {
            return Ok(await _context.SystemFeedbacks.ToListAsync());
        }
    }
}