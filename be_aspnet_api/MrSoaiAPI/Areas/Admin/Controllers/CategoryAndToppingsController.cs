using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using System.Data;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoryAndToppingsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public CategoryAndToppingsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ToppingNCategory>>> GetToppingNCategorys()

        {
            return await _context.ToppingNCategorys.Where(i => i.Status == true).Include(i=>i.Toppings).Include(i=>i.Category).ToListAsync();
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<ToppingNCategory>> GetToppingNCategorys(int id)
        {
            var ToppingNCategory = await _context.ToppingNCategorys.FindAsync(id);

            if (ToppingNCategory == null)
            {
                return NotFound();
            }

            return ToppingNCategory;
        }
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutToppingNCategory(int id, ToppingNCategory ToppingNCategory)
        {
            if (id != ToppingNCategory.Id)
            {
                return BadRequest();
            }

            _context.Entry(ToppingNCategory).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ToppingNCategoryExists(id))
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
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<ToppingNCategory>> PostToppingNCategory(AddCateP ToppingNCategory)
        {
            List<ToppingNCategory> ToppingNCategories = new();
            foreach (var item in ToppingNCategory.Listint)
            {
                ToppingNCategory x = new()
                {
                    CategoryId = item,
                    ToppingsId = ToppingNCategory.ToppingId,
                    Status = true
                };
                var TC = _context.ToppingNCategorys.Where(x => x.CategoryId == item && x.ToppingsId == ToppingNCategory.ToppingId).SingleOrDefault();
                if (TC == null)
                {
                    ToppingNCategories.Add(x);
                }
            }
            _context.ToppingNCategorys.AddRange(ToppingNCategories);
            await _context.SaveChangesAsync();

            return Ok();
        }
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteToppingNCategory(int id)
        {
            var ToppingNCategory = await _context.ToppingNCategorys.FindAsync(id);
            if (ToppingNCategory == null)
            {
                return NotFound();
            }

            ToppingNCategory.Status = false;
            _context.Entry(ToppingNCategory).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ToppingNCategoryExists(id))
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
        private bool ToppingNCategoryExists(int id)
        {
            return _context.ToppingNCategorys.Any(e => e.Id == id);
        }
    }

}

