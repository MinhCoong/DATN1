using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using MrSoaiAPI.Model.Authentication;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using static System.Net.WebRequestMethods;

namespace MrSoaiAPI.Controllers

{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class AuthenticateController : ControllerBase
    {

        private readonly UserManager<MrSoaiUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly MrSoaiAPIContext _context;
        private readonly SignInManager<MrSoaiUser> _signInManager;
        private readonly IConfiguration _configuration;
        private readonly IWebHostEnvironment _hostEnvironment;

        public AuthenticateController(
            UserManager<MrSoaiUser> userManager,
            RoleManager<IdentityRole> roleManager,
            MrSoaiAPIContext context,
            SignInManager<MrSoaiUser> signInManager,
            IConfiguration configuration,
            IWebHostEnvironment hostEnvironment
        )
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
            _signInManager = signInManager;
            _configuration = configuration;
            _hostEnvironment = hostEnvironment;

        }

        [HttpPost]
        [Route("Login")]
        public async Task<IActionResult> LoginInsider([FromBody] LoginInsiderModel model)
        {
            var result = await _signInManager.PasswordSignInAsync(model.UserName, model.Password, false, false);
            if (!result.Succeeded)
            {
                return Unauthorized();
            }
            var user = await _userManager.FindByNameAsync(model.UserName);
            if (!user.Status)
            {
                return BadRequest("User is not available!");
            }
            var userRoles = await _userManager.GetRolesAsync(user);

            var authClaims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.UserName),
                new Claim("Id", user.Id),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            };

            foreach (var userRole in userRoles)
            {
                authClaims.Add(new Claim(ClaimTypes.Role, userRole));
            }


            var identity = new ClaimsIdentity(authClaims);
            var claimsPrincipal = new ClaimsPrincipal(identity);
            // Set current principal
            HttpContext.User = claimsPrincipal;
            var token = GetToken(authClaims);
            return Ok(new
            {
                id=user.Id,
                role = userRoles[0],
                token = new JwtSecurityTokenHandler().WriteToken(token),
                expiration = token.ValidTo
            });
        }

        [HttpPost]
        [Route("RegisterOrLoginCustomer")]
        public async Task<IActionResult> RegisterOrLoginCustomer([FromBody] RegisterCustomerModel model)
        {
            var phoneNumberUserExists = await _context.Users.FirstOrDefaultAsync(u => u.AuthenPhoneNumberId == model.AuthenPhoneNumberId);
            var fbUserExists = await _context.Users.FirstOrDefaultAsync(u => u.FacebookUserId == model.FacebookUserId);
            var ggUserExists = await _context.Users.FirstOrDefaultAsync(u => u.GoogleUserId == model.GoogleUserId);
            if (phoneNumberUserExists != null)
            {
                var userRoles = await _userManager.GetRolesAsync(phoneNumberUserExists);

                var authClaims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, phoneNumberUserExists.AuthenPhoneNumberId),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                };

                foreach (var userRole in userRoles)
                {
                    authClaims.Add(new Claim(ClaimTypes.Role, userRole));
                }

                var token = GetToken(authClaims);

                return Ok(new
                {
                    
                    token = new JwtSecurityTokenHandler().WriteToken(token),
                    expiration = token.ValidTo
                });
            }
            else if (fbUserExists != null)
            {

                var userRoles = await _userManager.GetRolesAsync(fbUserExists);

                var authClaims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, fbUserExists.FacebookUserId),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                };

                foreach (var userRole in userRoles)
                {
                    authClaims.Add(new Claim(ClaimTypes.Role, userRole));
                }

                var token = GetToken(authClaims);

                return Ok(new
                {
                    token = new JwtSecurityTokenHandler().WriteToken(token),
                    expiration = token.ValidTo
                });
            }
            else if (ggUserExists != null)
            {

                var userRoles = await _userManager.GetRolesAsync(ggUserExists);

                var authClaims = new List<Claim>
                {
                    new Claim(ClaimTypes.Name, ggUserExists.GoogleUserId),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                };

                foreach (var userRole in userRoles)
                {
                    authClaims.Add(new Claim(ClaimTypes.Role, userRole));
                }

                var token = GetToken(authClaims);

                return Ok(new
                {
                    token = new JwtSecurityTokenHandler().WriteToken(token),
                    expiration = token.ValidTo
                });
            }

            //string imagePath = "https://172.16.4.131:8000/v1/api/ImageUploads/CustomerImage/UserMrsoai.png";
            string imagePath = "https://192.168.2.24:8000/v1/api/ImageUploads/CustomerImage/UserMrsoai.png";

            MrSoaiUser user = new()
            {
                SecurityStamp = Guid.NewGuid().ToString(),
                FirstName = model.FirstName == "" ? null : model.FirstName,
                LastName = model.LastName == "" ? null : model.LastName,
                AuthenPhoneNumberId = model.AuthenPhoneNumberId == "" ? null : model.AuthenPhoneNumberId,
                PhoneNumber = model.PhoneNumber == "" ? null : model.PhoneNumber,
                UserName = "MrSoaisCustomer-" + Guid.NewGuid().ToString(),
                FacebookUserId = model.FacebookUserId == "" ? null : model.FacebookUserId,
                GoogleUserId = model.GoogleUserId == "" ? null : model.GoogleUserId,
                Email = model.Email == "" ? null : model.Email,
                RegisterDatetime = DateTime.Now,
                Sex = null,
                DateOfBirth = DateTime.Now,
                Avatar = model.Avatar == "" ? imagePath : model.Avatar,
            };
            var result = await _userManager.CreateAsync(user);
            if (!result.Succeeded)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User creation failed! Please check user details and try again." });

            if (!await _roleManager.RoleExistsAsync(UserRoles.Customer))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.Customer));
            if (await _roleManager.RoleExistsAsync(UserRoles.Customer))
            {
                await _userManager.AddToRoleAsync(user, UserRoles.Customer);
            }
            string mrSoaiUser = null;
            if (user.AuthenPhoneNumberId != null)
            {
                mrSoaiUser = user.AuthenPhoneNumberId;

            }
            else if (user.FacebookUserId != null)
            {
                mrSoaiUser = user.FacebookUserId;

            }
            else if (user.GoogleUserId != null)
            {
                mrSoaiUser = user.GoogleUserId;

            }

            if (mrSoaiUser != null)
            {
                var userRoles = await _userManager.GetRolesAsync(user);
                var authClaims = new List<Claim>
                {
                new Claim(ClaimTypes.Name,mrSoaiUser),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                };

                foreach (var userRole in userRoles)
                {
                    authClaims.Add(new Claim(ClaimTypes.Role, userRole));
                }

                var token = GetToken(authClaims);
                var getUser = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == mrSoaiUser || p.FacebookUserId == mrSoaiUser || p.GoogleUserId == mrSoaiUser);
                if (getUser != null)
                {
                    var notification = new Model.Notification()
                    {
                        UserId = user.Id,
                        Title = "Xin Chào bạn mới",
                        Body = "Lần đầu đến với Mr Soái, Chúng mình sẽ cố gắng mang đến trải nghiệm tốt nhất cho bạn.",
                        CreatedAt = DateTime.Now,
                        Status = true
                    };
                    _context.Notifications.Add(notification);
                    _context.SaveChanges();
                }

                return Ok(new
                {
                    token = new JwtSecurityTokenHandler().WriteToken(token),
                    expiration = token.ValidTo
                });
            }
            return Unauthorized();
        }

        [HttpPost]
        [Route("RegisterAdmin/{roleUser}")]
        public async Task<IActionResult> RegisterInsider([FromBody] RegisterInsiderModel model, string roleUser)
        {
            var userExists = await _userManager.FindByNameAsync(model.UserName);
            if (userExists != null)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User already exists!" });

            var user = new MrSoaiUser
            {
                SecurityStamp = Guid.NewGuid().ToString(),
                FirstName = model.FirstName,
                LastName = model.LastName,
                UserName = model.UserName,
                PhoneNumber = model.PhoneNumber == "" ? null : model.PhoneNumber,
                RegisterDatetime = DateTime.Now,
                DateOfBirth = DateTime.Now,
                Sex = null,
            };
            //Mật khẩu cần có kí tự đặc biệt
            var result = await _userManager.CreateAsync(user, model.Password);
            if (!result.Succeeded)
                return StatusCode(StatusCodes.Status500InternalServerError, new Response { Status = "Error", Message = "User creation failed! Please check user details and try again." });

            if (!await _roleManager.RoleExistsAsync(UserRoles.Admin))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.Admin));
            if (!await _roleManager.RoleExistsAsync(UserRoles.Staff))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.Staff));
            if (!await _roleManager.RoleExistsAsync(UserRoles.Customer))
                await _roleManager.CreateAsync(new IdentityRole(UserRoles.Customer));


            if (await _roleManager.RoleExistsAsync(roleUser))
            {
                await _userManager.AddToRoleAsync(user, roleUser);
            }
            return Ok(new Response { Status = "Success", Message = "User created successfully!" });
        }

        private JwtSecurityToken GetToken(List<Claim> authClaims)
        {
            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["JWT:Secret"]));

            var token = new JwtSecurityToken(
                issuer: _configuration["JWT:ValidIssuer"],
                audience: _configuration["JWT:ValidAudience"],
                expires: DateTime.Now.AddHours(24),
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha512Signature)
                );

            return token;
        }

        [HttpPost("Logout")]
        public async Task<ActionResult> Logout()
        {
            await _signInManager.SignOutAsync();
            return Ok();
        }
    }
}
