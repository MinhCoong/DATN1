using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("/v1/api/product")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;

        public ProductsController(MrSoaiAPIContext context, IWebHostEnvironment hostEnvironment)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;

        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
        {
            return await _context.Products.Where(i=>i.Status==true).Include(p=>p.Category).ToListAsync();
        }

        [HttpGet("Folderpath")]
        public IActionResult GetFolderPath()
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images");
            return Ok(imagesFolderPath);
        }
        // GET: api/Products/5
        [HttpGet("Search")]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts(string? productName)
        {
            if(productName == null)
            {
                return await _context.Products.Include(p => p.Category).Include(p => p.Prices).ThenInclude(i => i.Size).ToListAsync();

            }
            return  await _context.Products.Where(i => i.ProductName.Contains(productName)&&i.Status==true).Include(p => p.Category).Include(p => p.Prices).ThenInclude(i => i.Size).ToListAsync(); ;
        }
    }
}
