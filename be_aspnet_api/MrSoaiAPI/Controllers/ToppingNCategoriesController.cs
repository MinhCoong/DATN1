using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class ToppingNCategoriesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public ToppingNCategoriesController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/ToppingNCategories
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ToppingNCategory>>> GetToppingNCategorys()
        {
            return await _context.ToppingNCategorys.Include(p=>p.Toppings).ToListAsync();
        }

        [HttpGet("Topping")]
        public async Task<ActionResult<IEnumerable<Topping>>> GetToppings()
        {
            return await _context.Toppings.Where(i=>i.Status==true).ToListAsync();
        }

       
    }
}
