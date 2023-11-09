using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class AddressesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public AddressesController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/Addresses
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Address>>> GetAddresses(string userId)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            if(User == null)
            {
                NotFound();
            }
            return await _context.Addresses.Where(i=>i.UserId==User.Id).ToListAsync();
        }

        [HttpPut("UpdateAddress/{id}")]
        public async Task<IActionResult> PutAddress(int id, Address address)
        {
            if (id != address.Id)
            {
                return BadRequest();
            }

            _context.Entry(address).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AddressExists(id))
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
       
        [HttpPost]
        public async Task<ActionResult<Address>> PostAddress(Address address)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == address.UserId || p.FacebookUserId == address.UserId || p.GoogleUserId == address.UserId);

            address.UserId = User.Id;
            _context.Addresses.Add(address);
            await _context.SaveChangesAsync();

            return Ok(address);
        }

        // DELETE: api/Addresses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAddress(int id)
        {
            var address = await _context.Addresses.FindAsync(id);
            if (address == null)
            {
                return NotFound();
            }

            _context.Addresses.Remove(address);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AddressExists(int id)
        {
            return _context.Addresses.Any(e => e.Id == id);
        }
    }
}
