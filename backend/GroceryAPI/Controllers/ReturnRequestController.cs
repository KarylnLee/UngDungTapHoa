using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReturnRequestController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ReturnRequestController(AppDbContext context) { _context = context; }

        [HttpPost("request")]
        public async Task<IActionResult> RequestReturn([FromBody] ReturnRequest req)
        {
            req.RequestedAt = DateTime.Now;
            req.Status = "Đang xử lý";
            _context.ReturnRequests.Add(req);
            await _context.SaveChangesAsync();
            return Ok("Yêu cầu đổi/trả đã được gửi");
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserReturns(int userId)
        {
            var list = await _context.ReturnRequests
                .Include(r => r.Order)
                .Where(r => r.Order.UserId == userId)
                .ToListAsync();
            return Ok(list);
        }
    }
}