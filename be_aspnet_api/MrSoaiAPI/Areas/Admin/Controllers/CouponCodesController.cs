using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;
using Microsoft.AspNetCore.Authorization;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/coupon")]
    [ApiController]

    public class CouponCodesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IImageHandler _imageHandler;
        public CouponCodesController(MrSoaiAPIContext context, IWebHostEnvironment hostEnvironment, IImageHandler imageHandler)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
            _imageHandler = imageHandler;
        }
        [HttpGet("/couponimages/{imageName}")]
        public IActionResult Get(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\coupons");

            Byte[] b = System.IO.File.ReadAllBytes(imagesFolderPath + "\\" + imageName);   // You can use your own method over here.         
            return File(b, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("Folderpath")]
        public IActionResult GetFolderPath()
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\coupons");
            return Ok(imagesFolderPath);
        }
        // GET: api/CouponCodes
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CouponCode>>> GetCoupon()
        {
            return await _context.CouponCodes.Where(i => i.Status == true).Include(p => p.User).ToListAsync();
        }
        [Authorize(Roles = "Admin")]
        // GET: api/News/5
        [HttpGet("{id}")]
        public async Task<ActionResult<CouponCode>> GetCoupon(int id)
        {
            var coupon = await _context.CouponCodes.FindAsync(id);

            if (coupon == null)
            {
                return NotFound();
            }

            return coupon;
        }
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<CouponCode>> PostNews([FromForm] CouponCode coupon)
        {
            var user = await _context.Users.FirstOrDefaultAsync(c => c.Id == coupon.UserId);
            if(user == null)
            {
                return BadRequest("Not Found User!");
            }
            var imageName = await _imageHandler.UploadImageCoupon(coupon.ImageFile);
            var newcoupon = new CouponCode
            {
                UserId = user.Id,
                Code = coupon.Code,
                Title = coupon.Title,
                Discount = coupon.Discount,
                Description = coupon.Description,
                Image = imageName,
                StartDate = coupon.StartDate,
                EndDate = coupon.EndDate,
                Point = coupon.Point,
                MinimumQuantity = coupon.MinimumQuantity,
                MinimumTotla = coupon.MinimumTotla,
                Status = true
            };

            _context.CouponCodes.Add(newcoupon);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCoupon", new { id = newcoupon.Id }, newcoupon);
        }
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutCoupon(int id, [FromForm] CouponCode coupon)
        {
            var update = await _context.CouponCodes.FindAsync(id);

            if (coupon.ImageFile != null)
            {
                var imageName = await _imageHandler.UploadImageCoupon(coupon.ImageFile);
                update.UserId = coupon.UserId;
                update.Description = coupon.Description;
                update.Title = coupon.Title;
                update.Image = imageName;
                update.Code = coupon.Code;
                update.StartDate = coupon.StartDate;
                update.EndDate = coupon.EndDate;
                update.Point = coupon.Point;
                update.MinimumQuantity = coupon.MinimumQuantity;
                update.MinimumTotla = coupon.MinimumTotla;
            }
            else
            {
                update.UserId = coupon.UserId;
                update.Description = coupon.Description;
                update.Title = coupon.Title;
                update.Code = coupon.Code;
                update.StartDate = coupon.StartDate;
                update.EndDate = coupon.EndDate;
                update.Point = coupon.Point;
                update.MinimumQuantity = coupon.MinimumQuantity;
                update.MinimumTotla = coupon.MinimumTotla;
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCoupon(int id)
        {
            var coupon = await _context.CouponCodes.FindAsync(id);
            if (coupon == null)
            {
                return NotFound();
            }
            coupon.Status = false;
            _context.Entry(coupon).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }

            catch (DbUpdateConcurrencyException e)
            {
                Console.WriteLine(e);

            }

            return NoContent();
        }
    }
}
