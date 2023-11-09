using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Handler;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;
using System.Data;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class AccountCustomersController : ControllerBase
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly UserManager<MrSoaiUser> _userManager;
        private readonly MrSoaiAPIContext _context;

        public AccountCustomersController(MrSoaiAPIContext context, IHttpContextAccessor httpContextAccessor, UserManager<MrSoaiUser> userManager)
        {
            _context = context;
            _httpContextAccessor = httpContextAccessor;
            _userManager = userManager;
        }

        [HttpGet("GetCustomer/{userId}")]
        public async Task<IActionResult> GetCustomer(string userId)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            if (User == null)
            {
                return NotFound();
            }

            return Ok(User);
        }

        [HttpPut]
        public async Task<IActionResult> PutCustomer(MrSoaiUser customer)
        {
            var user = _context.Users.SingleOrDefault(i=>i.Id == customer.Id);
            if (user == null)
            {
                return BadRequest();
            }


            user.FirstName = customer.FirstName;
            user.LastName = customer.LastName;
            user.Email = customer.Email;
            user.PhoneNumber = customer.PhoneNumber;
            user.Sex = customer.Sex;
            user.DateOfBirth = customer.DateOfBirth;
            user.Avatar= customer.Avatar;

            IdentityResult result = await _userManager.UpdateAsync(user);

            if (result.Succeeded)
            {
                return Ok(result);
            }
            else
            {
                return BadRequest();
            }
        }
    }
}
