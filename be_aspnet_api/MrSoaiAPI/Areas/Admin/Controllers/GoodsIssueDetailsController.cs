using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GoodsIssueDetailsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public GoodsIssueDetailsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<GoodsIssueDetail>>> GetInventoryCheckDetails()
        {
            return await _context.GoodsIssueDetails.ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<GoodsIssueDetail>> GetInventoryCheckDetails(int id)
        {
            var InventoryCheckDetail = await _context.GoodsIssueDetails.FindAsync(id);

            if (InventoryCheckDetail == null)
            {
                return NotFound();
            }

            return InventoryCheckDetail;
        }

        [HttpPost]
        public async Task<ActionResult<GoodsIssueDetail>> PostInventoryCheckDetail([FromBody] List<GoodsIssueDetail> inventoryCheckDetail)
        {
            var list = new List<GoodsIssueDetail>();
            var listIC = await _context.GoodsIssues.OrderByDescending(x => x.Id).FirstOrDefaultAsync();
            foreach (var item in inventoryCheckDetail)
            {
                item.GoodsIssueId = listIC.Id;
                list.Add(item);
            }
            _context.GoodsIssueDetails.AddRange(list);
            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
