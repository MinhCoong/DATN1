using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using MrSoaiAPI.Model.Authentication;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly UserManager<MrSoaiUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly IConfiguration _configuration;
        private readonly MrSoaiAPIContext _context;

        public UsersController(MrSoaiAPIContext context, IHttpContextAccessor httpContextAccessor, UserManager<MrSoaiUser> userManager, RoleManager<IdentityRole> roleManager, IConfiguration configuration)
        {
            _context = context;
            _httpContextAccessor = httpContextAccessor;
            _userManager = userManager;
            _roleManager = roleManager;
            _configuration = configuration;
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("Customer")]
        public async Task<ActionResult<IEnumerable<MrSoaiUser>>> GetCustomer()
        {
            var roleId = await _roleManager.FindByNameAsync(UserRoles.Customer);
            var users = await _context.UserRoles.Where(i => i.RoleId == roleId.Id)
                .GroupBy(i => i.UserId)
                .Select(i => new { UserId = i.Key })
                .Join(_context.Users, u => u.UserId, user => user.Id, (u, user) => new MrSoaiUser
                {
                    Id = user.Id,
                    UserName = user.UserName,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    PhoneNumber = user.PhoneNumber,
                })
            .ToListAsync();

            return users;
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("Insider")]
        public async Task<ActionResult<IEnumerable<MrSoaiUser>>> GetUserInsider()
        {
            var roleId = await _roleManager.FindByNameAsync(UserRoles.Customer);
            var users = await _context.Roles.Where(i => i.Id != roleId.Id)
                //.GroupBy(i => i.UserId)
                //.Select(i => new { UserId = i.Key })
                .Join(_context.UserRoles, q => q.Id, userRoles => userRoles.RoleId, (q, userRoles) => new
                {
                    RoleId = q.Id,
                    UserId = userRoles.UserId,
                })
                .Join(_context.Users, u => u.UserId, user => user.Id, (u, user) => new MrSoaiUser
                {
                    Id = user.Id,
                    UserName = user.UserName,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    PhoneNumber = user.PhoneNumber,
                    Status = user.Status,
                    AuthenPhoneNumberId = _context.Roles.SingleOrDefault(i => i.Id == u.RoleId).Name,
                }).Where(i => i.Status == true)
                .ToListAsync();

            return users;
        }

        [HttpPut]
        public async Task<IActionResult> PutCustomer(MrSoaiUser customer)
        {
            var user = _context.Users.SingleOrDefault(i => i.Id == customer.Id);
            if (user == null)
            {
                return BadRequest();
            }

            user.FirstName = customer.FirstName;
            user.LastName = customer.LastName;
            user.UserName = customer.UserName;
            user.PhoneNumber = customer.PhoneNumber;
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

        [HttpPost]
        [Route("reset-password/{userId}")]
        public async Task<IActionResult> ResetPassword(string userId, LoginInsiderModel model)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return BadRequest("Invalid user ID");
            }


            // Reset mật khẩu
            await _userManager.RemovePasswordAsync(user);
            var result = await _userManager.AddPasswordAsync(user, model.Password);
            if (result.Succeeded)
            {
                return Ok("ResetPasswordConfirmation");
            }
            else
            {
                return BadRequest("Failed to reset password");
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{userId}")]
        public async Task<IActionResult> DeleteUser(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return NotFound();
            }

            //var result = await _userManager.DeleteAsync(user);
            //if (!result.Succeeded)
            //{
            //    return BadRequest(result.Errors);
            //}
            var role= _context.Roles.SingleOrDefault(x => x.Name == UserRoles.Admin);
            var roleus = _context.UserRoles.SingleOrDefault(i => i.UserId == user.Id);
            var rd= _context.Roles.SingleOrDefault(_ => _.Id ==roleus.RoleId);
            if (_context.UserRoles.Where(i => i.RoleId == role.Id).ToList().Count() > 1||rd.Name==UserRoles.Staff)
            {
                user.Status = false;
                _context.Entry(user).State = EntityState.Modified;
                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException e)
                {
                    Console.WriteLine(e);
                }
            }

            return NoContent();
        }
    }
}