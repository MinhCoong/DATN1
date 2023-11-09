using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using System.Data;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/category")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class CategorysController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public CategorysController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Category>>> GetCategorys()
        {
            return await _context.Categorys.Where(i=>i.Status==true).ToListAsync();
        }


        // GET api/<CategorysController>/5

        [HttpGet("{id}")]
        public async Task<ActionResult<Category>> GetCategory(int id)
        {
            var category = await _context.Categorys.FindAsync(id);

            if (category == null)
            {
                return NotFound();
            }

            return category;
        }

        // POST api/<CategorysController>
        [HttpPost]
        public async Task<ActionResult<Category>> PostCategory([FromForm]Category category)
        {
            var newcatetgory = new Category
            {
                CategoryName = category.CategoryName,
                Status = true
            };
            _context.Categorys.Add(newcatetgory);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCategory", new { id = newcatetgory.Id }, newcatetgory);
        }


        // PUT api/<CategorysController>/5

        [HttpPut("{id}")]
        public async Task<IActionResult> PutCategory(int id, Category category)
        {
            if (id != category.Id)
            {
                return BadRequest();
            }

            _context.Entry(category).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CategoryExists(id))
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

        // DELETE api/<CategorysController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCategory(int id)
        {
            var cate = await _context.Categorys.FindAsync(id);
            if (cate == null)
            {
                return BadRequest();
            }
           

            cate.Status = false;
            _context.Entry(cate).State = EntityState.Modified;

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
        private bool CategoryExists(int id)
        {
            return _context.Categorys.Any(e => e.Id == id);
        }
    }
}
