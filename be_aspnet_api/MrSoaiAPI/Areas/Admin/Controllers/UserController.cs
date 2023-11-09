using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [ApiController]
    [Route("/[area]/v1/api/user")]
    public class UserController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public UserController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<MrSoaiUser>>> GetUser()
        {
            return await _context.Users.ToListAsync();
        }


        // GET api/<SizesController>/5

        [HttpGet("{id}")]
        public async Task<ActionResult<MrSoaiUser>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        // PUT: api/Sizes/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(int id, MrSoaiUser user)
        {
            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
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
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Size>> PostUsers(MrSoaiUser user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.Id }, user);
        }

        // DELETE: api/Sizes/5
        /*[HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.Sizes.Remove(user);
            await _context.SaveChangesAsync();

            return NoContent();
        }*/
        private bool UserExists(int id)
        {
            return _context.Sizes.Any(e => e.Id == id);
        }
    }
}