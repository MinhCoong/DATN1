using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;
using System.Data;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [ApiController]
    [Route("/[area]/v1/api/topping")]
    
    public class ToppingsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IImageHandler _imageHandler;
        public ToppingsController(MrSoaiAPIContext context, IWebHostEnvironment hostEnvironment, IImageHandler imageHandler)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
            _imageHandler = imageHandler;
        }
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Topping>>> GetToppings()
        {
            return await _context.Toppings.Where(i => i.Status == true).ToListAsync();
        }
        [HttpGet("/upload/{imageName}")]
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
        // GET api/<ToppingsController>/5
        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<Topping>> GetToppings(int id)
        {
            var topping = await _context.Toppings.FindAsync(id);

            if (topping == null)
            {
                return NotFound();
            }

            return topping;
        }

        // POST api/<ToppingsController>
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<Topping>> GetToppings([FromForm] Topping topping)
        {
            var imageName = await _imageHandler.UploadImageProduct(topping.ImageFile);
            var newTopping = new Topping
            {
                ToppingName = topping.ToppingName,
                Price = topping.Price,
                Image = imageName,
                Status = true
            };
            _context.Toppings.Add(newTopping);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetToppings", new { id = newTopping.Id }, newTopping);
        }


        // PUT api/<ToppingsController>/5
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> GetToppings(int id, [FromForm] Topping topping)
        {
            var update = await _context.Toppings.FindAsync(id);
            if (topping.ImageFile != null)
            {
                var imageName = await _imageHandler.UploadImageProduct(topping.ImageFile);
                update.ToppingName = topping.ToppingName;
                update.Price = topping.Price;
                update.Image = imageName;
            }
            else
            {
                update.ToppingName = topping.ToppingName;
                update.Price = topping.Price;
            }
           
            await _context.SaveChangesAsync();
            return NoContent();
        }



        // DELETE api/<ToppingsController>/5
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteToppings(int id)
        {
            var topping = await _context.Toppings.FindAsync(id);
            if (topping == null)
            {
                return NotFound();
            }

            topping.Status = false;
            _context.Entry(topping).State = EntityState.Modified;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ToppingExists(id))
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
        private bool ToppingExists(int id)
        {
            return _context.Toppings.Any(e => e.Id == id);
        }
    }
}
