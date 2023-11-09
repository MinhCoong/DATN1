using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InventoryAuditingsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public InventoryAuditingsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<GoodsIssue>>> GetGoodsIssues()
        {
            var listIC = await _context.GoodsIssues.OrderByDescending(x => x.Id).FirstOrDefaultAsync();
            if (listIC != null)
            {
                var listICDT = await _context.GoodsIssueDetails.FirstOrDefaultAsync(i => i.GoodsIssueId == listIC.Id);
                if (listICDT == null)
                {
                    _context.GoodsIssues.Remove(listIC);
                    await _context.SaveChangesAsync();
                }
            }
            return await _context.GoodsIssues.Where(i => i.Status == false).Include(i => i.User).OrderByDescending(x => x.Id).ToListAsync();
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

        [HttpPost("InventoryAuditing")]
        public async Task<IActionResult> InventoryAuditing(DateTime dateTime, string userId)
        {

            var listOrder = _context.Orders.Where(i => i.OrderDate.Day == dateTime.Day && i.OrderDate.Month == dateTime.Month && i.OrderDate.Year == dateTime.Year && i.OrderStatus != 1 && i.OrderStatus != 0).ToList();
            if (listOrder.Any())
            {
                var user = _context.Users.SingleOrDefault(i => i.Id == userId);
                if (user == null)
                {
                    return BadRequest("Not Found User");
                }
                GoodsIssue GoodIsueX = new()
                {
                    UserId = user.Id,
                    CheckDatime = DateTime.Now,
                    Description = dateTime.ToString(),
                    Status = false
                };
                _context.GoodsIssues.Add(GoodIsueX);
                await _context.SaveChangesAsync();
                var GI = await _context.GoodsIssues.OrderByDescending(i => i.Id).FirstOrDefaultAsync();
                foreach (var order in listOrder)
                {
                    var orderDetail = _context.OrderDetails.Where(i => i.OrderId == order.Id)
                        .Include(i => i.Product)
                        .Include(i => i.OrderdetailToppingList).ThenInclude(i => i.Toppings)
                        .ToList();
                    foreach (var orderdt in orderDetail)
                    {
                        var Quantum = _context.Quantums.Where(i => i.ProductName == orderdt.Product.ProductName).ToList();
                        if (Quantum.Any())
                        {
                            foreach (var itemQuantum in Quantum)
                            {
                                var IngredienT = _context.Ingredients.SingleOrDefault(i => i.Id == itemQuantum.IngredientsId);
                                var x = orderdt.Quantity * itemQuantum.Quantity;

                                var GoodDl = _context.GoodsIssueDetails.SingleOrDefault(i => i.GoodsIssueId == GI.Id && i.IngredientsId == itemQuantum.IngredientsId);
                                if (GoodDl != null)
                                {
                                    GoodDl.Quantity += x;
                                    _context.Entry(GoodDl).State = EntityState.Modified;
                                }
                                else
                                {
                                    GoodsIssueDetail goodsIssueDetail = new()
                                    {
                                        GoodsIssueId = GI.Id,
                                        IngredientsId = IngredienT.Id,
                                        Quantity = x,
                                        Status = true
                                    };
                                    _context.GoodsIssueDetails.Add(goodsIssueDetail);
                                }
                                await _context.SaveChangesAsync();
                            }
                        }

                        foreach (var item in orderdt.OrderdetailToppingList)
                        {
                            var QuantumTopping = _context.Quantums.Where(i => i.ProductName == item.Toppings.ToppingName).ToList();
                            if (QuantumTopping.Any())
                            {
                                foreach (var itemQuantum in QuantumTopping)
                                {
                                    var IngredienT = _context.Ingredients.SingleOrDefault(i => i.Id == itemQuantum.IngredientsId);
                                    var x = orderdt.Quantity * itemQuantum.Quantity;

                                    var GoodDl = _context.GoodsIssueDetails.SingleOrDefault(i => i.GoodsIssueId == GI.Id && i.IngredientsId == itemQuantum.IngredientsId);
                                    if (GoodDl != null)
                                    {
                                        GoodDl.Quantity += x;
                                        _context.Entry(GoodDl).State = EntityState.Modified;
                                    }
                                    else
                                    {
                                        GoodsIssueDetail goodsIssueDetail = new()
                                        {
                                            GoodsIssueId = GI.Id,
                                            IngredientsId = IngredienT.Id,
                                            Quantity = x,
                                            Status = true
                                        };
                                        _context.GoodsIssueDetails.Add(goodsIssueDetail);
                                    }
                                    await _context.SaveChangesAsync();
                                }
                            }
                        }
                    }
                }

                return Ok();
            }
            return NoContent();
        }
    }
}
