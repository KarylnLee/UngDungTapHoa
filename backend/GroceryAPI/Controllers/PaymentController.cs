using Microsoft.AspNetCore.Mvc;
using GroceryAPI.Models;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using Microsoft.AspNetCore.Authorization;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class PaymentController : ControllerBase
    {
        private readonly AppDbContext _context;
        public PaymentController(AppDbContext context) { _context = context; }

        [HttpPost("process/{orderId}")]
        public IActionResult ProcessPayment(int orderId, [FromBody] PaymentDto dto)
        {
            var order = _context.Orders.Find(orderId);
            if (order == null) return NotFound();

            // Logic giả lập thanh toán (cần tích hợp Momo/ZaloPay)
            if (dto.PaymentMethod == "momo" || dto.PaymentMethod == "zalopay")
            {
                order.Status = "completed";
                _context.SaveChanges();
                return Ok("Thanh toán thành công qua " + dto.PaymentMethod);
            }
            return BadRequest("Phương thức thanh toán không hỗ trợ.");
        }
    }

    public class PaymentDto
    {
        public required string PaymentMethod { get; set; }
    }
}