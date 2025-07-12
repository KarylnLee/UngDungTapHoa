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
    public class ProductController : ControllerBase
    {
        private readonly AppDbContext _context;
        public ProductController(AppDbContext context) { _context = context; }

        [HttpPost("add")]
        public async Task<IActionResult> AddProduct([FromBody] Product product)
        {
            _context.Products.Add(product);
            await _context.SaveChangesAsync();
            return Ok("Thêm sản phẩm thành công");
        }

        [HttpPut("update/{id}")]
        public async Task<IActionResult> UpdateProduct(int id, [FromBody] Product product)
        {
            var prod = await _context.Products.FindAsync(id);
            if (prod == null) return NotFound();
            prod.Name = product.Name;
            prod.CategoryId = product.CategoryId;
            prod.Brand = product.Brand;
            prod.Description = product.Description;
            prod.Unit = product.Unit;
            prod.Stock = product.Stock;
            prod.Price = product.Price;
            prod.ImageURL = product.ImageURL;
            prod.Ingredients = product.Ingredients;
            await _context.SaveChangesAsync();
            return Ok("Cập nhật sản phẩm thành công");
        }

        [HttpDelete("delete/{id}")]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            var prod = await _context.Products.FindAsync(id);
            if (prod == null) return NotFound();
            _context.Products.Remove(prod);
            await _context.SaveChangesAsync();
            return Ok("Xóa sản phẩm thành công");
        }

        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> GetProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);
            return product == null ? NotFound() : Ok(product);
        }

        [HttpGet("all")]
        [AllowAnonymous]
        public async Task<IActionResult> GetAllProducts()
        {
            return Ok(await _context.Products.ToListAsync());
        }
    }
}