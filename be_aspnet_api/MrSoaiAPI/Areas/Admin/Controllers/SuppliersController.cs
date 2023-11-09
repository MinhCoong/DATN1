using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using Microsoft.AspNetCore.Authorization;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class SuppliersController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public SuppliersController(MrSoaiAPIContext context)
        {
            _context = context;
        }
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Supplier>>> GetSupplier()
        {
            return await _context.Suppliers.Where(i=>i.Status==true).ToListAsync();
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<Supplier>> GetSupplier(int id)
        {
            var supplier = await _context.Suppliers.SingleOrDefaultAsync(i=>i.Id==id&&i.Status==true);

            if (supplier == null)
            {
                return NotFound();
            }

            return supplier;
        }
        [Authorize(Roles = "Admin")]
        [HttpGet("Search/{supplier}")]
        public async Task<ActionResult<IEnumerable<Supplier>>> GetSearchSupplier(string supplierX)
        {
            var supplier = await _context.Suppliers
                .Where(i => i.Status == true
                &&(i.SupplierEmail==supplierX||i.SupplierName==supplierX||i.SupplierAddress==supplierX||i.SupplierPhoneNumber==supplierX))
                .ToListAsync();

            return supplier;
        }
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutSupplier(int id, Supplier supplier)
        {
            if (id != supplier.Id)
            {
                return BadRequest();
            }

            _context.Entry(supplier).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SupplierExists(id))
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
        public async Task<ActionResult<Supplier>> PostSupplier(Supplier supplier)
        {
            _context.Suppliers.Add(supplier);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetSize", new { id = supplier.Id }, supplier);
        }
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSupplier(int id)
        {
            var supplier = await _context.Suppliers.FindAsync(id);
            if (supplier == null)
            {
                return NotFound();
            }
            supplier.Status = false;
            _context.Entry(supplier).State = EntityState.Modified;
            await _context.SaveChangesAsync();

            return NoContent();
        }
        private bool SupplierExists(int id)
        {
            return _context.Sizes.Any(e => e.Id == id);
        }
    }
}
