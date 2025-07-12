using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using GroceryAPI.Data;
using Microsoft.EntityFrameworkCore;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ReviewController(AppDbContext context) { _context = context; }

        [HttpPost("submit")]
        public async Task<IActionResult> SubmitReview([FromBody] Review review)
        {
            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();
            return Ok("Đã gửi đánh giá");
        }

        [HttpGet("product/{productId}")]
        public async Task<IActionResult> GetReviews(int productId)
        {
            return Ok(await _context.Reviews.Where(r => r.ProductId == productId).ToListAsync());
        }
    }
}