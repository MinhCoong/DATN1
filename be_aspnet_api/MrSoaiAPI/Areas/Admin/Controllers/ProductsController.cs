using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/product")]
    [ApiController]
    
    public class ProductsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IImageHandler _imageHandler;

        public ProductsController(MrSoaiAPIContext context, IWebHostEnvironment hostEnvironment, IImageHandler imageHandler)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
            _imageHandler = imageHandler;
        }
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
        {
            return await _context.Products.Where(i => i.Status == true).Include(p => p.Category).ToListAsync();
        }


        [HttpGet("/uploadimages/{imageName}")]
        public IActionResult Get(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\products");

            Byte[] b = System.IO.File.ReadAllBytes(imagesFolderPath + "\\" + imageName);   // You can use your own method over here.         
            return File(b, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("Folderpath")]
        public IActionResult GetFolderPath()
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images");
            return Ok(imagesFolderPath);
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProduct(int id)
        {
            var product = await _context.Products.Include(p => p.Category).SingleOrDefaultAsync(i => i.Id == id);

            if (product == null)
            {
                return NotFound();
            }

            return product;
        }
        [Authorize(Roles = "Admin")]
        // POST api/<ProductsController>
        [HttpPost]
        public async Task<ActionResult<Product>> PostProduct([FromForm] Product product)
        {
            var category = await _context.Categorys.FirstOrDefaultAsync(c => c.Id == product.CategoryId);
            var imageName = await _imageHandler.UploadImageProduct(product.ImageFile);
            var newProduct = new Product
            {
                ProductName = product.ProductName,
                Description = product.Description,
                CategoryId = category.Id,
                Image =  imageName,
                Status = true
            };

            _context.Products.Add(newProduct);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProduct", new { id = newProduct.Id }, newProduct);
        }


        // PUT api/<ProductsController>/5
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProduct( int id, [FromForm] Product product)
        {
            var update = await _context.Products.FindAsync(id);
            if (update == null)
            {
                return BadRequest();
            }
            if (product.ImageFile != null)
            {
                var imageName = await _imageHandler.UploadImageProduct(product.ImageFile);
                update.ProductName = product.ProductName;
                update.Description = product.Description;
                update.CategoryId = product.CategoryId;
                update.Image = imageName;
            }
            else
            {
                update.ProductName = product.ProductName;
                update.Description = product.Description;
                update.CategoryId = product.CategoryId;
            }
           
            await _context.SaveChangesAsync();

            return NoContent();
        }
        // DELETE api/<ProductsController>/5
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            product.Status = false;
            _context.Entry(product).State = EntityState.Modified;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ProductExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }
        private bool ProductExists(int id)
        {
            return _context.Products.Any(e => e.Id == id);
        }
        [HttpGet("Search")]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts(string? productName)
        {
            if (productName == null)
            {
                return await _context.Products.Include(p => p.Category).Include(p => p.Prices).ThenInclude(i => i.Size).ToListAsync();

            }
            return await _context.Products.Include(p => p.Category).Include(p => p.Prices).ThenInclude(i => i.Size).Where(i => i.ProductName.Contains(productName)).ToListAsync(); ;
        }
    }
}
