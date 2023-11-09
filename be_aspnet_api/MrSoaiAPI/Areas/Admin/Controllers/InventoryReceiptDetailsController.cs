using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class InventoryReceiptDetailsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public InventoryReceiptDetailsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<InventoryReceiptDetail>>> GetInventoryReceiptDetails()
        {
            return await _context.InventoryReceiptDetails.Include(e=>e.Ingredients).ToListAsync();
        }

        [HttpPost]
        public async Task<ActionResult<InventoryReceiptDetail>> PostInventoryReceiptDetail([FromBody] List<InventoryReceiptDetail> listInventoryReceiptDetails)
        {
            List<InventoryReceiptDetail> lst = new();
            
            var listIR = await _context.InventoryReceipts.OrderByDescending(x => x.Id).FirstOrDefaultAsync();
            foreach (var item in listInventoryReceiptDetails)
            {
                item.InventoryReceiptsId = listIR.Id;
                lst.Add(item);
                listIR.TotalValue += item.Subtotal;
            }
            _context.Entry(listIR).State=EntityState.Modified;
            _context.InventoryReceiptDetails.AddRange(lst);
            await _context.SaveChangesAsync();

            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInventoryReceiptDetail(int id)
        {
            var inventoryReceipDetails = await _context.InventoryReceiptDetails.FindAsync(id);
            if (inventoryReceipDetails == null)
            {
                return NotFound();
            }

            _context.InventoryReceiptDetails.Remove(inventoryReceipDetails);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
