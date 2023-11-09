using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class NotificationsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public NotificationsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/News
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Notification>>> GetNews(string userId)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            if (User == null)
            {
                return BadRequest();
            }
            return await _context.Notifications.Where(s => s.CreatedAt>=User.RegisterDatetime&&(s.UserId==User.Id||s.UserId== "AllUser")).ToListAsync();
        }

        [HttpPut("UpdateStatus/{id}")]
        public async Task<ActionResult<Notification>> UpdateStatus(int id)
        {
            var noti = _context.Notifications.SingleOrDefault(i=>i.Id==id);
            if (noti == null)
            {
                return BadRequest();
            }

            noti.Status = false;
            _context.Entry(noti).State=EntityState.Modified;
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException e)
            {
                Console.WriteLine(e);
            }

            return Ok();
        }

        [HttpDelete("Delete/{id}")]
        public async Task<ActionResult<Notification>> DeleteNotifi(int id)
        {
            var noti = _context.Notifications.SingleOrDefault(i => i.Id == id);
            if (noti == null)
            {
                return BadRequest();
            }
            _context.Remove(noti);
            await _context.SaveChangesAsync();
            return Ok();
        }
    }
}
