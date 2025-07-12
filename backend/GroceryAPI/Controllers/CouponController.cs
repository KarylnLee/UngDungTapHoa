using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using Microsoft.AspNetCore.Authorization;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = "admin")]
    public class CouponController : ControllerBase
    {
        private readonly AppDbContext _context;
        public CouponController(AppDbContext context) { _context = context; }

        [HttpGet("check/{code}")]
        [AllowAnonymous]
        public async Task<IActionResult> CheckCoupon(string code)
        {
            var coupon = await _context.Coupons.FirstOrDefaultAsync(c => c.Code == code && c.IsActive && c.ExpiryDate >= DateTime.Now);
            if (coupon == null) return NotFound("Mã không hợp lệ hoặc đã hết hạn");
            return Ok(coupon);
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddCoupon([FromBody] Coupon coupon)
        {
            _context.Coupons.Add(coupon);
            await _context.SaveChangesAsync();
            return Ok("Thêm mã giảm giá thành công");
        }

        [HttpPut("update/{id}")]
        public async Task<IActionResult> UpdateCoupon(int id, [FromBody] Coupon coupon)
        {
            var existing = await _context.Coupons.FindAsync(id);
            if (existing == null) return NotFound();
            existing.Code = coupon.Code;
            existing.DiscountValue = coupon.DiscountValue;
            existing.ExpiryDate = coupon.ExpiryDate;
            existing.MinOrderAmount = coupon.MinOrderAmount;
            existing.IsActive = coupon.IsActive;
            await _context.SaveChangesAsync();
            return Ok("Cập nhật mã giảm giá thành công");
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteCoupon(int id)
        {
            var coupon = await _context.Coupons.FindAsync(id);
            if (coupon == null) return NotFound();
            _context.Coupons.Remove(coupon);
            await _context.SaveChangesAsync();
            return Ok("Xóa mã giảm giá thành công");
        }
    }
}