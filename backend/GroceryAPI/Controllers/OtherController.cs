using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using GroceryAPI.Data;
using GroceryAPI.Models;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OtpController : ControllerBase
    {
        private readonly AppDbContext _context;
        public OtpController(AppDbContext context) => _context = context;

         [HttpPost("send")]
        public IActionResult SendOtp([FromBody] OtpRequest model)
        {
            // Log thử model.Code để test
            Console.WriteLine($"OTP gửi: {model.Code}");
            return Ok("Gửi OTP thành công");
        }

        [HttpPost("add")]
        public async Task<IActionResult> AddOtp([FromBody] Otp otp)
        {
            _context.Otps.Add(otp);
            await _context.SaveChangesAsync();
            return Ok("OTP saved");
        }

        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetOtpByUser(int userId)
        {
            var otps = await _context.Otps.Where(x => x.UserId == userId).ToListAsync();
            return Ok(otps);
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class DeliveryChatController : ControllerBase
    {
        private readonly AppDbContext _context;
        public DeliveryChatController(AppDbContext context) => _context = context;

        [HttpPost("send")]
        public async Task<IActionResult> SendMessage([FromBody] DeliveryChat chat)
        {
            _context.DeliveryChats.Add(chat);
            await _context.SaveChangesAsync();
            return Ok("Message sent");
        }

        [HttpGet("order/{orderId}")]
        public async Task<IActionResult> GetChatByOrder(int orderId)
        {
            var messages = await _context.DeliveryChats.Where(x => x.OrderId == orderId).ToListAsync();
            return Ok(messages);
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class QnAController : ControllerBase
    {
        private readonly AppDbContext _context;
        public QnAController(AppDbContext context) => _context = context;

        [HttpPost("ask")]
        public async Task<IActionResult> AskQuestion([FromBody] QnA qna)
        {
            _context.QnAs.Add(qna);
            await _context.SaveChangesAsync();
            return Ok("Câu hỏi đã được gửi");
        }

        [HttpGet("product/{productId}")]
        public async Task<IActionResult> GetByProduct(int productId)
        {
            var qnaList = await _context.QnAs.Where(q => q.ProductId == productId).ToListAsync();
            return Ok(qnaList);
        }
    }
}
