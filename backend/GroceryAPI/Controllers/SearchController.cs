using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SearchController : ControllerBase
    {
        private readonly AppDbContext _context;
        public SearchController(AppDbContext context) { _context = context; }

        [HttpPost("save")]
        public async Task<IActionResult> SaveSearch([FromBody] SearchHistory history)
        {
            if (history.Keyword.Length > 100) return BadRequest("Từ khóa quá dài");
            history.SearchedAt = DateTime.Now;
            _context.SearchHistories.Add(history);
            await _context.SaveChangesAsync();
            return Ok("Đã lưu từ khóa tìm kiếm");
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetHistory(int userId)
        {
            var history = await _context.SearchHistories
                .Where(h => h.UserId == userId)
                .OrderByDescending(keySelector: h => h.SearchedAt)
                .Take(20)
                .ToListAsync();
            return Ok(history);
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteKeyword(int id)
        {
            var item = await _context.SearchHistories.FindAsync(id);
            if (item == null) return NotFound();
            _context.SearchHistories.Remove(item);
            await _context.SaveChangesAsync();
            return Ok("Đã xoá từ khoá");
        }

        [HttpDelete("clear/{userId}")]
        public async Task<IActionResult> ClearHistory(int userId)
        {
            var list = _context.SearchHistories.Where(h => h.UserId == userId);
            _context.SearchHistories.RemoveRange(list);
            await _context.SaveChangesAsync();
            return Ok("Đã xoá toàn bộ lịch sử");
        }
    }
}