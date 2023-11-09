using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GoodsIssuesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public GoodsIssuesController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<GoodsIssue>>> GetGoodsIssues()
        {
            var listIC = await _context.GoodsIssues.OrderByDescending(x => x.Id).FirstOrDefaultAsync();
            if(listIC != null) {
                var listICDT = await _context.GoodsIssueDetails.FirstOrDefaultAsync(i => i.GoodsIssueId == listIC.Id);
                if (listICDT == null)
                {
                    _context.GoodsIssues.Remove(listIC);
                    await _context.SaveChangesAsync();
                }
            }
            return await _context.GoodsIssues.Where(i=>i.Status==true).Include(i=>i.User).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<GoodsIssue>> GetInventoryCheck(int id)
        {
            var inventoryCheck = await _context.GoodsIssues.Include(i => i.User).Include(i => i.GoodsIssueDetails).ThenInclude(i => i.Ingredients).Where(i => i.Id == id).SingleOrDefaultAsync();

            if (inventoryCheck == null)
            {
                return NotFound();
            }

            return inventoryCheck;
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutInventoryCheck(int id, GoodsIssue inventoryCheck)
        {
            if (id != inventoryCheck.Id)
            {
                return BadRequest();
            }

            _context.Entry(inventoryCheck).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!InventoryCheckExists(id))
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
        public async Task<ActionResult<GoodsIssue>> PostInventoryCheck(GoodsIssue inventoryCheck)
        {

            inventoryCheck.UserId = inventoryCheck.UserId;
            _context.GoodsIssues.Add(inventoryCheck);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetInventoryCheck", new { id = inventoryCheck.Id }, inventoryCheck);
        }

        private bool InventoryCheckExists(int id)
        {
            return _context.GoodsIssues.Any(e => e.Id == id);
        }
    }
}
