using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class InventoryReceiptsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public InventoryReceiptsController(MrSoaiAPIContext context)
        {
            _context = context;
        }


        [HttpGet]
        public async Task<ActionResult<IEnumerable<InventoryReceipt>>> GetInventoryReceipts()
        {
            var listIR = await _context.InventoryReceipts.OrderByDescending(i => i.Id).FirstOrDefaultAsync();
           if(listIR != null)
            {
                var listIRDT = await _context.InventoryReceiptDetails.FirstOrDefaultAsync(i => i.Id == listIR.Id);
                if (listIRDT == null)
                {
                    _context.InventoryReceipts.Remove(listIR);
                    await _context.SaveChangesAsync();
                }
            }

            return await _context.InventoryReceipts.Include(i => i.User)
                .Include(i => i.InventoryReceiptDetails).ThenInclude(i => i.Ingredients)
                .OrderByDescending(i => i.Id).ToListAsync();
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<InventoryReceipt>> GetInventoryReceipt(int id)
        {
            var inventoryReceipt = await _context.InventoryReceipts.Include(i=>i.User).Include(i=>i.InventoryReceiptDetails).ThenInclude(i=>i.Ingredients).Where(i=>i.Id==id).SingleOrDefaultAsync();

            if (inventoryReceipt == null)
            {
                return NotFound();
            }

            return inventoryReceipt;
        }


        [HttpPut("{id}")]
        public async Task<IActionResult> PutInventoryReceipt(int id, InventoryReceipt inventoryReceipt)
        {
            if (id != inventoryReceipt.Id)
            {
                return BadRequest();
            }

            _context.Entry(inventoryReceipt).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!InventoryReceiptExists(id))
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

        [HttpPut("UpdateStatus/{id}")]
        public async Task<IActionResult> UpdateStatusIR(int id, InventoryReceipt inventoryReceipt)
        {
            if (id != inventoryReceipt.Id)
            {
                return BadRequest();
            }
            var ListIngredients = _context.InventoryReceiptDetails.Where(x => x.InventoryReceiptsId == id).ToList();
            foreach (var item in ListIngredients)
            {
                var ingre= _context.Ingredients.SingleOrDefault(id => id.Id == item.IngredientsId);
                ingre.Quantity += item.Quantity;
                
                _context.Entry(ingre).State = EntityState.Modified;
                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException e)
                {
                   Console.WriteLine(e.ToString());
                }
            }

            inventoryReceipt.Status = true;

            _context.Entry(inventoryReceipt).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!InventoryReceiptExists(id))
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
        public async Task<ActionResult<InventoryReceipt>> PostInventoryReceipt(InventoryReceipt inventoryReceipt)
        { 

            inventoryReceipt.UserId = inventoryReceipt.UserId;
            _context.InventoryReceipts.Add(inventoryReceipt);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInventoryReceipt", new { id = inventoryReceipt.Id }, inventoryReceipt);
        }

        private bool InventoryReceiptExists(int id)
        {
            return _context.InventoryReceipts.Any(e => e.Id == id);
        }
    }
}
