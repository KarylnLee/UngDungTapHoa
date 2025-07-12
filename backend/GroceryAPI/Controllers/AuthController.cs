using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using System.Security.Cryptography;
using System.Text;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Authorization;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AuthController(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest model)
        {
            // Kiểm tra email đã tồn tại
            if (await _context.Users.AnyAsync(u => u.Email == model.Email))
                return BadRequest("Email already registered.");

            // Tạo mới User từ model
            var user = new User
            {
                FullName = model.FullName,
                Email = model.Email,
                PhoneNumber = model.PhoneNumber,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.Password),
                AuthProvider = "local",
                CreatedAt = DateTime.UtcNow,
                IsActive = true
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "User registered successfully.", userId = user.UserId });
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == dto.Email || u.PhoneNumber == dto.Email);
            if (user == null)
                return Unauthorized("Email hoặc SĐT không tồn tại.");

            bool isValid = BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash);
            if (!isValid)
                return Unauthorized("Mật khẩu không chính xác.");

            var role = await _context.Admins.AnyAsync(a => a.UserId == user.UserId) ? "admin" : "user";

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, role), // Sử dụng role từ kiểm tra
                new Claim(JwtRegisteredClaimNames.Exp, DateTimeOffset.UtcNow.AddHours(2).ToUnixTimeSeconds().ToString())
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("jwt_secret_key!@#abcxyzTUYENsecureKey02112005"));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(2),
                signingCredentials: creds
            );

            string jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return Ok(new
            {
                message = "Login success",
                token = jwt,
                user = new { user.UserId, user.Email, user.FullName, user.PhoneNumber, user.AuthProvider }
            });
        }

        [Authorize]
        [HttpPut("update-password")]
        [Authorize]
        public async Task<IActionResult> UpdatePassword([FromBody] UpdatePasswordDto dto)
        {
            var userIdString = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdString) || !int.TryParse(userIdString, out int userId))
            {
                return Unauthorized("Token không hợp lệ hoặc thiếu thông tin.");
            }
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return NotFound();

            if (!BCrypt.Net.BCrypt.Verify(dto.CurrentPassword, user.PasswordHash))
                return BadRequest("Mật khẩu hiện tại không chính xác.");

            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.NewPassword);
            await _context.SaveChangesAsync();
            return Ok("Cập nhật mật khẩu thành công.");
        }

        [Authorize]
        [HttpGet("check-admin/{userId}")]
        [Authorize]
        public async Task<IActionResult> CheckAdminRole(int userId)
        {
            var isAdmin = await _context.Admins.AnyAsync(a => a.UserId == userId);
            return Ok(new { isAdmin });
        }

    }

    public class LoginDto
    {
        public required string Email { get; set; } // Sử dụng Email hoặc SĐT
        public required string Password { get; set; }
    }

    public class UpdatePasswordDto
    {
        public required string CurrentPassword { get; set; }
        public required string NewPassword { get; set; }
    }
}