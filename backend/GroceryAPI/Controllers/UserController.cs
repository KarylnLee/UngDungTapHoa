using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Data;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Concurrent;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly AppDbContext _context;
        private static readonly ConcurrentDictionary<int, string> _otpStorage = new();
        public UserController(AppDbContext context) { _context = context; }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            return user == null ? NotFound() : Ok(user);
        }

        [HttpPut("update")]
        public async Task<IActionResult> UpdateUser([FromBody] User user)
        {
            var u = await _context.Users.FindAsync(user.UserId);
            if (u == null) return NotFound();
            u.FullName = user.FullName;
            u.PhoneNumber = user.PhoneNumber;
            await _context.SaveChangesAsync();
            return Ok("Cập nhật thành công");
        }

        // Demo gửi OTP (in console)
        [HttpPost("send-otp")]
        public IActionResult SendOtp([FromQuery] int userId)
        {
            var otp = new Random().Next(100000, 999999).ToString();
            _otpStorage[userId] = otp;
            Console.WriteLine($"[DEMO] OTP for user {userId}: {otp}");
            return Ok("OTP đã được gửi (demo)");
        }

        [HttpPost("verify-otp")]
        public IActionResult VerifyOtp([FromQuery] int userId, [FromQuery] string otp)
        {
            if (_otpStorage.TryGetValue(userId, out var storedOtp) && storedOtp == otp)
            {
                _otpStorage.TryRemove(userId, out _);
                return Ok("Xác thực thành công");
            }
            return BadRequest("OTP không hợp lệ hoặc đã hết hạn");
        }

        // Địa chỉ giao hàng
        [HttpGet("addresses/{userId}")]
        public async Task<IActionResult> GetAddresses(int userId)
        {
            return Ok(await _context.ShippingAddresses.Where(a => a.UserId == userId).ToListAsync());
        }

        [HttpPost("address/add")]
        public async Task<IActionResult> AddAddress([FromBody] ShippingAddress address)
        {
            _context.ShippingAddresses.Add(address);
            await _context.SaveChangesAsync();
            return Ok("Đã thêm địa chỉ");
        }

        [HttpPut("address/update")]
        public async Task<IActionResult> UpdateAddress([FromBody] ShippingAddress address)
        {
            var addr = await _context.ShippingAddresses.FindAsync(address.AddressId);
            if (addr == null) return NotFound();
            addr.FullAddress = address.FullAddress;
            addr.IsDefault = address.IsDefault;
            await _context.SaveChangesAsync();
            return Ok("Đã cập nhật địa chỉ");
        }

        [HttpDelete("address/delete/{id}")]
        public async Task<IActionResult> DeleteAddress(int id)
        {
            var addr = await _context.ShippingAddresses.FindAsync(id);
            if (addr == null) return NotFound();
            _context.ShippingAddresses.Remove(addr);
            await _context.SaveChangesAsync();
            return Ok("Đã xóa địa chỉ");
        }
    }
}
