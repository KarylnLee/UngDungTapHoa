using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using Microsoft.AspNetCore.Authorization;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DeliveryController : ControllerBase
    {
        private readonly AppDbContext _context;
        public DeliveryController(AppDbContext context) { _context = context; }

        [HttpPost("track")]
        public async Task<IActionResult> TrackOrder([FromBody] DeliveryTracking tracking)
        {
            tracking.UpdatedAt = DateTime.Now;
            _context.DeliveryTracking.Add(tracking);
            await _context.SaveChangesAsync();
            return Ok("Cập nhật trạng thái giao hàng");
        }

        [HttpGet("status/{orderId}")]
        public async Task<IActionResult> GetTrackingStatus(int orderId)
        {
            var status = await _context.DeliveryTracking
                .Where(t => t.OrderId == orderId)
                .OrderByDescending(t => t.UpdatedAt)
                .FirstOrDefaultAsync();
            return status == null ? NotFound("Không có trạng thái") : Ok(status);
        }

        [HttpPost("rate/{orderId}")]
        [Authorize]
        public async Task<IActionResult> RateOrder(int orderId, [FromBody] RatingDto dto)
        {
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null) return NotFound();
            if (dto.DeliveryRating < 1 || dto.DeliveryRating > 5 || dto.ShipperRating < 1 || dto.ShipperRating > 5)
                return BadRequest("Đánh giá phải từ 1 đến 5.");

            order.DeliveryRating = dto.DeliveryRating;
            await _context.SaveChangesAsync();
            return Ok("Đánh giá thành công");
        }
    }

    public class RatingDto
    {
        public int DeliveryRating { get; set; }
        public int ShipperRating { get; set; }
    }
}