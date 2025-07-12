using Microsoft.AspNetCore.Mvc;
using System.Collections.Concurrent;

namespace GroceryAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChatController : ControllerBase
    {
        private static readonly ConcurrentDictionary<string, List<ChatMessage>> chatStore = new();

        [HttpPost("send")]
        public IActionResult Send([FromBody] ChatMessage msg)
        {
            var key = GenerateKey(msg.FromUserId, msg.ToUserId);
            if (!chatStore.ContainsKey(key)) chatStore[key] = new List<ChatMessage>();
            msg.Timestamp = DateTime.Now;
            chatStore[key].Add(msg);
            return Ok("Tin nhắn đã gửi (demo)");
        }

        [HttpGet("history")]
        public IActionResult GetHistory(int fromUserId, int toUserId)
        {
            var key = GenerateKey(fromUserId, toUserId);
            return Ok(chatStore.ContainsKey(key) ? chatStore[key] : new List<ChatMessage>());
        }

        private string GenerateKey(int a, int b) => a < b ? $"{a}-{b}" : $"{b}-{a}";
    }

    public class ChatMessage
    {
        public int FromUserId { get; set; }
        public int ToUserId { get; set; }
        public required string Message { get; set; }
        public DateTime Timestamp { get; set; }
    }
}