using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using MrSoaiAPI.Model.Authentication;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class RegistrationTokensController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public RegistrationTokensController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/RegistrationTokens
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RegistrationToken>>> GetRegistrationTokens()
        {
            return await _context.RegistrationTokens.ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<RegistrationToken>> PostRegistrationToken(RegistrationToken registrationToken)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == registrationToken.UserId || p.FacebookUserId == registrationToken.UserId || p.GoogleUserId == registrationToken.UserId);
            if(User == null)
            {
                return NotFound();
            }
            if(registrationToken == null)
            {
                return NotFound();
            }else if(_context.RegistrationTokens.SingleOrDefault(i=>i.DeviceToken==registrationToken.DeviceToken&&i.UserId==User.Id)!=null) {
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "Device token already exists" });
            }

            registrationToken.UserId=User.Id;
            _context.RegistrationTokens.Add(registrationToken);
            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
