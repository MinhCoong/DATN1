using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class SlidersController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IImageHandler _imageHandler;

        public SlidersController(MrSoaiAPIContext context, IWebHostEnvironment hostEnvironment, IImageHandler imageHandler)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
            _imageHandler = imageHandler;
        }

        [HttpGet("/uploadImgSlider/{imageName}")]
        public IActionResult Get(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\sliders");

            Byte[] b = System.IO.File.ReadAllBytes(imagesFolderPath + "\\" + imageName);   // You can use your own method over here.         
            return File(b, "image/" + imageName.Split(".")[1]);
        }
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Slider>>> GetSizes()
        {
            return await _context.Sliders.ToListAsync();
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<Slider>> GetSlider(int id)
        {
            var slider = await _context.Sliders.FindAsync(id);

            if (slider == null)
            {
                return BadRequest("Invalid slider ID");
            }

            return slider;
        }

        // PUT: api/Sizes/5
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSize(int id, Slider slider)
        {
            if (id != slider.Id)
            {
                return BadRequest("Invalid slider ID");
            }

            _context.Entry(slider).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SliderExists(id))
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

        // POST: api/Sizes
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<Slider>> PostSlider([FromForm] Slider slider)
        {
            var imageName = await _imageHandler.UploadImageSlider(slider.ImageFile);

            var sliderX = new Slider()
            {
                ImageSlider = imageName,
                DateAdd = DateTime.Now,
                Status = true
            };
            _context.Sliders.Add(sliderX);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetSize", new { id = slider.Id }, slider);
        }

        // DELETE: api/Sizes/5
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSlider(int id)
        {
            var slider = await _context.Sliders.FindAsync(id);
            if (slider == null)
            {
                return BadRequest("Invalid slider ID");
            }
            //string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\slider\\");slider.ImageSlider
            //var isDelete = await _imageHandler.DeleteImage(imagesFolderPath);
            //if (!isDelete)
            //{
            //    return BadRequest("Image can not delete");
            //}
            _context.Sliders.Remove(slider);
            await _context.SaveChangesAsync();

            return NoContent();
        }
        private bool SliderExists(int id)
        {
            return _context.Sliders.Any(e => e.Id == id);
        }
    }
}
