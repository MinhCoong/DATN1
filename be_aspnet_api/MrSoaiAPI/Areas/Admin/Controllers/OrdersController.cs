using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/order")]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public OrdersController(MrSoaiAPIContext context)
        {
            _context = context;
        }
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrders()
        {
            return await _context.Orders.OrderByDescending(i => i.OrderDate).ToListAsync();
        }
        [HttpGet("DC")]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrdersDN()
        {
            return await _context.Orders.OrderByDescending(i => i.OrderDate).Where(i=>i.OrderStatus == 0).ToListAsync();
        }

        [HttpGet("static")]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrdersStatus()
        {
            return await _context.Orders.Where(i=>i.OrderDate.Date==DateTime.Now.Date&&i.OrderDate.Month<=DateTime.Now.Month&&i.OrderDate.Year==DateTime.Now.Year).OrderBy(i => i.OrderStatus).ToListAsync();
        }
        [HttpGet("{id}/detail")]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrders(int id)
        {
            return await _context.Orders
                .Where(o => o.Id == id) // Lọc theo id
                .Include(i => i.Coupons)
                .Include(i => i.OrderDetails)
                .ThenInclude(i => i.Product)
                .Include(i=>i.OrderDetails)
                .ThenInclude(i=>i.Size)
                .Include(i => i.OrderDetails)
                .ThenInclude(i => i.OrderdetailToppingList)
                .ToListAsync();
        }
        // GET: api/Orders
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrders(string userId)
        {
            var user = await _context.Users.SingleOrDefaultAsync(p => p.PhoneNumber == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            return await _context.Orders.Include(i => i.User).Include(i => i.Coupons).Include(i => i.OrderDetails).Where(i => i.UserId == user.Id).ToListAsync();
        }
        [HttpPut("{id}/detail")]
        public async Task<IActionResult> PutOrder(int id, Order order)
        {
            if (id != order.Id)
            {
                return BadRequest();
            }
            var orderX = _context.Orders.Find(id);
            if(orderX.OrderStatus==order.OrderStatus-1)
            {
                if(order.OrderStatus==2)
                {
                    var listOrderDt = _context.OrderDetails.Where(i=>i.OrderId==orderX.Id)
                        .Include(i=>i.Product)
                        .Include(i=>i.OrderdetailToppingList).ThenInclude(i=>i.Toppings)
                        .ToList();
                    foreach(var itemOdt in listOrderDt)
                    {
                        var Quantum = _context.Quantums.Where(i=>i.ProductName==itemOdt.Product.ProductName).Include(i=>i.Ingredients).ToList();
                        if (Quantum.Any())
                        {
                            foreach (var itemQt in Quantum)
                            {
                                var ItemIng = _context.Ingredients.SingleOrDefault(i=>i.Id==itemQt.IngredientsId);
                                ItemIng.Quantity -= itemOdt.Quantity*itemQt.Quantity;
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
                }
                if (order.OrderStatus == 3)
                {
                    var user = _context.Users.SingleOrDefault(i => i.Id == orderX.UserId);
                    if (user == null)
                    {
                        return BadRequest("Not found User");
                    }
                    if (orderX.CouponsId != 1)
                    {
                        var coupons = _context.CouponCodes.SingleOrDefault(i => i.Id == orderX.CouponsId);
                        if (coupons.Discount > 1000)
                        {
                            user.Point = Convert.ToInt32((orderX.Total + orderX.DeliveryCharges - coupons.Discount) / 10000);
                        }
                        else
                        {
                            user.Point = Convert.ToInt32((orderX.Total + orderX.DeliveryCharges) * coupons.Discount / 10000);
                        }
                    }
                    else
                    {
                        user.Point = Convert.ToInt32((orderX.Total + orderX.DeliveryCharges) / 10000);
                    }

                    _context.Users.Update(user);
                }
                orderX.OrderStatus = order.OrderStatus;
                _context.Entry(orderX).State = EntityState.Modified;

                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!OrderExists(id))
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
            else
            {
                return BadRequest();
            }
        }

        [HttpPost]
        public async Task<ActionResult<Order>> PostOrder(Order order)
        {
            var user = await _context.Users.SingleOrDefaultAsync(p => p.PhoneNumber == order.UserId || p.FacebookUserId == order.UserId || p.GoogleUserId == order.UserId);


            var codeOrder = RandomCodeOrder();

            order.DeliveryTime = Convert.ToDateTime(order.DeliveryTime.ToString());
            order.OrderDate = DateTime.Now;
            order.Code = codeOrder;
            order.UserId = user.Id;

            var addOrder = new Order()
            {
                Code = codeOrder,

            };

            _context.Orders.Add(order);
            _context.SaveChanges();

            //tìm giỏ hàng ủa khách
            var listCartUser = await _context.Carts.Where(i => i.UserId == user.Id).ToListAsync();
            if (listCartUser.Any())
            {
                var exitOrder = await _context.Orders.SingleOrDefaultAsync(p => p.Code == order.Code);
                foreach (var item in listCartUser)
                {
                    var priceProduct = await _context.Prices.SingleOrDefaultAsync(i => i.ProductId == item.ProductId && i.SizeId == item.SizeId);

                    var codeOD = RandomCodeOrderDetail();
                    //thêm sp từ giỏ hàng
                    var orderDetails = new OrderDetail()
                    {
                        Code = codeOD,
                        OrderId = exitOrder.Id,
                        ProductId = item.ProductId,
                        SizeId = item.SizeId,
                        Quantity = item.Quantity,
                        Price = priceProduct.PriceOfProduct,
                        Desciption = item.Desciption,
                        Subtotal = item.PriceProduct,
                    };

                    _context.OrderDetails.Add(orderDetails);
                    _context.SaveChanges();

                    var lstTopping = await _context.CartNToppings.Include(p => p.Toppings).Where(p => p.Id == item.Id).ToListAsync();

                    if (lstTopping.Any())
                    {
                        //thêm topping nếu trong sản phẩmm có
                        var exitOderDetail = _context.OrderDetails.SingleOrDefault(p => p.Code == orderDetails.Code);
                        foreach (var itemTopping in lstTopping)
                        {
                            var orderDtTopping = new OrderDetailNTopping
                            {
                                OrderDetailId = exitOderDetail.Id,
                                ToppingsId = itemTopping.Id,
                                Status = true
                            };

                            _context.OrderDetailsNToppings.Add(orderDtTopping);
                            _context.SaveChanges();

                        }

                        _context.CartNToppings.RemoveRange(lstTopping);
                    }
                }

                _context.Carts.RemoveRange(listCartUser);

                if (order.CouponsId != 1)
                {
                    var coupons = _context.CouponCodes.SingleOrDefault(i => i.Id == order.CouponsId);
                    if (coupons.Discount > 1000)
                    {
                        user.Point = Convert.ToInt32((order.Total + order.DeliveryCharges - coupons.Discount) / 1000);
                    }
                    else
                    {
                        user.Point = Convert.ToInt32((order.Total + order.DeliveryCharges) * coupons.Discount / 1000);
                    }
                }
                else
                {
                    user.Point = Convert.ToInt32((order.Total + order.DeliveryCharges) / 1000);
                }
                _context.Users.Update(user);


                await _context.SaveChangesAsync();
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
        private bool OrderExists(int id)
        {
            return _context.Orders.Any(e => e.Id == id);
        }
    }
}
