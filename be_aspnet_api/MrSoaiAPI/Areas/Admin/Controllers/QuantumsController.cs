using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class QuantumsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public QuantumsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Quantum>>> GetQuantums()
        {
            return await _context.Quantums.Where(i => i.Status == true).Include(i=>i.Ingredients).ToListAsync();
        }

        [HttpGet("GetProductAndTopping")]
        public async Task<ActionResult<IEnumerable<Category>>> GetProductsAndToppings()
        {
            return await _context.Categorys.Where(i => i.Status == true).Include(i=>i.Products.Where(i => i.Status == true)).Include(i=>i.Toppings.Where(i => i.Status == true)).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Quantum>> GetQuantum(int id)
        {
            var quantum = await _context.Quantums.FindAsync(id);

            if (quantum == null)
            {
                return NotFound();
            }

            return quantum;
        }

        [HttpPost]
        public async Task<ActionResult<Quantum>> PostQuantum([FromBody]AddQuantums q)
        {
            List<Quantum> lstQuantum = new();
            foreach (var ingredients in q.ListIngredientAndQuantity)
            {
                var x = new Quantum()
                {
                    ProductName = q.ProductName,
                    IngredientsId = ingredients.IngredientId,
                    Quantity = ingredients.Quantity,
                    Status = true
                };
                lstQuantum.Add(x);
            }
            _context.Quantums.AddRange(lstQuantum);  
            await _context.SaveChangesAsync();
            return Ok();
        }
        [HttpPut("{id}")]
        public async Task<IActionResult> PutQuantum(int id, Quantum quantum)
        {
            if (id != quantum.Id)
            {
                return BadRequest();
            }
            var quantums = _context.Quantums.SingleOrDefault(i => i.Id == id);
            quantums.Quantity = quantum.Quantity;
            _context.Entry(quantums).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!QuantumExists(id))
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
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteQuantum(int id)
        {
            var quantum = await _context.Quantums.FindAsync(id);
            if (quantum == null)
            {
                return NotFound();
            }

            quantum.Status = false;
            _context.Entry(quantum).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!QuantumExists(id))
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
        private bool QuantumExists(int id)
        {
            return _context.Quantums.Any(e => e.Id == id);
        }
    }
}
