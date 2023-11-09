using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class CouponCodesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public CouponCodesController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/CouponCodes
        [HttpGet("{userId}")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CouponCode>>> GetCouponCodes(string userId)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            return await _context.CouponCodes.Where(i => i.Point <= User.Point && i.StartDate <= DateTime.Now && i.EndDate >= DateTime.Now && i.Status == true).ToListAsync();
        }

        //// GET: api/CouponCodes/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<CouponCode>> GetCouponCode(int id)
        //{
        //    var couponCode = await _context.CouponCodes.FindAsync(id);

        //    if (couponCode == null)
        //    {
        //        return NotFound();
        //    }

        //    return couponCode;
        //}    
    }
}
