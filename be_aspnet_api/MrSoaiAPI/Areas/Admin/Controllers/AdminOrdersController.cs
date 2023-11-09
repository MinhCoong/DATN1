using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class AdminOrdersController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public AdminOrdersController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrder()
        {
            return await _context.Orders.Include(i => i.User).Include(i => i.Coupons)
                .ToListAsync();
        }

        [HttpGet("Search/{order}")]
        public async Task<ActionResult<IEnumerable<Order>>> GetSearchOrder(string order)
        {
            return await _context.Orders.Include(i => i.User).Include(i => i.Coupons)
                .Where(i => i.Code.Contains(order) || i.User.UserName.Contains(order))
                .ToListAsync();
        }

        [HttpGet("Statistics")]
        public async Task<ActionResult<IEnumerable<Order>>> GetStatistics(DateTime dateStart, DateTime dateEnd)
        {
            return await _context.Orders.Include(i => i.User).Include(i => i.Coupons)
                .Where(i => i.OrderDate >= dateStart && i.OrderDate <= dateEnd)
                .ToListAsync();
        }

        //[HttpPost]
        [HttpPost("user")]
        public async Task<ActionResult<Cart>> AddOrder([FromBody] List<AddCart> addListCart, string paymentMethod)
        {
            
            var codeOrder = RandomCodeOrder();
            var total = 0.0;
            foreach (var cart in addListCart)
            {
                var endPrice = _context.Prices.SingleOrDefault(i => i.ProductId == cart.ProductId && i.SizeId == cart.SizeId);
                if (endPrice == null)
                {
                    return BadRequest("endPrice is emty");
                }
                var priceLTopping = 0.0;
                if (cart.ToppingSelect.Count() > 0)
                {
                    foreach (var item in cart.ToppingSelect)
                    {
                        var price = _context.Toppings.Find(item);
                        priceLTopping += price.Price;
                    }
                }
                total += priceLTopping + endPrice.PriceOfProduct;
            }
            var order = new Order()
            {
                Code = codeOrder,
                OrderDate = DateTime.Now,
                UserId = addListCart[0].UserId,
                DeliveryTime = DateTime.Now,
                CouponsId = 1,
                DeliveryMethod = "Tại quán",
                PaymentMethod = paymentMethod,
                Total = total,
                OrderStatus = 3,
            };
            _context.Orders.Add(order);
            _context.SaveChanges();

            var exitOrder = await _context.Orders.SingleOrDefaultAsync(p => p.Code == order.Code);
            foreach (var item in addListCart)
            {
                var endPrice = _context.Prices.SingleOrDefault(i => i.ProductId == item.ProductId && i.SizeId == item.SizeId);
                if (endPrice == null)
                {
                    return BadRequest("endPrice is emty");
                }

                var codeOD = RandomCodeOrderDetail();
                //thêm sp từ giỏ hàng
                var orderDetails = new OrderDetail()
                {
                    Code = codeOD,
                    OrderId = exitOrder.Id,
                    ProductId = item.ProductId,
                    SizeId = item.SizeId,
                    Quantity = item.Quantity,
                    Price = endPrice.PriceOfProduct,
                    Desciption = item.Description,
                    Subtotal = item.PriceProduct,
                };

                _context.OrderDetails.Add(orderDetails);
                _context.SaveChanges();

                if (item.ToppingSelect.Any())
                {
                    var exitOderDetail = _context.OrderDetails.SingleOrDefault(p => p.Code == orderDetails.Code);
                    foreach (var topping in item.ToppingSelect)
                    {
                        var orderDtTopping = new OrderDetailNTopping()
                        {
                            OrderDetailId = exitOderDetail.Id,
                            ToppingsId = topping,
                            Status = true
                        };

                        _context.OrderDetailsNToppings.Add(orderDtTopping);
                        _context.SaveChanges();
                    }
                }
            }

            var listOrderDt = _context.OrderDetails.Where(i => i.OrderId == exitOrder.Id)
                        .Include(i => i.Product)
                        .Include(i => i.OrderdetailToppingList).ThenInclude(i => i.Toppings)
                        .ToList();
            foreach (var itemOdt in listOrderDt)
            {
                var Quantum = _context.Quantums.Where(i => i.ProductName == itemOdt.Product.ProductName).Include(i => i.Ingredients).ToList();
                if (Quantum.Any())
                {
                    foreach (var itemQt in Quantum)
                    {
                        var ItemIng = _context.Ingredients.SingleOrDefault(i => i.Id == itemQt.IngredientsId);
                        ItemIng.Quantity -= itemOdt.Quantity * itemQt.Quantity;
                        _context.Entry(ItemIng).State = EntityState.Modified;
                        try
                        {
                            await _context.SaveChangesAsync();
                        }
                        catch (DbUpdateConcurrencyException)
                        {
                            if (!_context.Ingredients.Any(e => e.Id == ItemIng.Id))
                            {
                                return NotFound();
                            }
                            else
                            {
                                throw;
                            }
                        }
                    }
                }

                foreach (var item in itemOdt.OrderdetailToppingList)
                {
                    var QuantumToppings = _context.Quantums.Where(i => i.ProductName == item.Toppings.ToppingName).ToList();
                    if (QuantumToppings.Any())
                    {
                        foreach (var itemQt in QuantumToppings)
                        {
                            var ItemIng = _context.Ingredients.SingleOrDefault(i => i.Id == itemQt.IngredientsId);
                            ItemIng.Quantity -= itemOdt.Quantity * itemQt.Quantity;
                            _context.Entry(ItemIng).State = EntityState.Modified;
                            try
                            {
                                await _context.SaveChangesAsync();
                            }
                            catch (DbUpdateConcurrencyException)
                            {
                                if (!_context.Ingredients.Any(e => e.Id == ItemIng.Id))
                                {
                                    return NotFound();
                                }
                                else
                                {
                                    throw;
                                }
                            }
                        }
                    }
                }
            }

            return Ok();
        }

        private string RandomCodeOrder()
        {
            var rnd = new Random();
            int num;
            string Code;
            do
            {
                num = rnd.Next();
                Code = num.ToString();

            } while (_context.Orders.SingleOrDefault(i => i.Code == Code) != null);

            return Code;
        }

        private string RandomCodeOrderDetail()
        {
            var rnd = new Random();
            int num;
            string Code;
            do
            {
                num = rnd.Next();
                Code = num.ToString();

            } while (_context.OrderDetails.SingleOrDefault(i => i.Code == Code) != null);

            return Code;
        }
    }
}
