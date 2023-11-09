using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using System.Data;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class CategoriesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public CategoriesController(MrSoaiAPIContext context)
        {
            _context = context;
        }
        
        // GET: api/Categories
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Category>>> GetCategorys()
        {
            return await _context.Categorys.Where(c=>c.Status==true).Include(p => p.Products.Where(i => i.Status == true)).ThenInclude(p=>p.Prices.Where(i => i.Status == true)).ThenInclude(i=>i.Size).ToListAsync();
        }

        // GET: api/Categories/5
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
    }
}
