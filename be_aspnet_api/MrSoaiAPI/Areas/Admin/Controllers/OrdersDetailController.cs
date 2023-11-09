using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/orderdetail")]
    [ApiController]
    public class OrdersDetailController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public OrdersDetailController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/Prices
        [HttpGet]
        public  async Task<ActionResult<IEnumerable<OrderDetail>>> GetOrderDetail()
        {
            return await _context.OrderDetails.Include(q => q.Size).Include(p=>p.OrderdetailToppingList).ToListAsync();
        }

        // GET: api/Prices/5
        [HttpGet("{id}")]
        public async Task<ActionResult<OrderDetail>> GetOrderDetail(int id)
        {
            var orderDetail = await _context.OrderDetails.FindAsync(id);

            if (orderDetail == null)
            {
                return NotFound();
            }

            return orderDetail;
        }

    }
}
