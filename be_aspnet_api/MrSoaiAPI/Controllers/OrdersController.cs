using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Hubs;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IHubContext<WebSocketHub> _hub;

        public OrdersController(MrSoaiAPIContext context, IHubContext<WebSocketHub> hub)
        {
            _context = context;
            _hub = hub;
        }

        // GET: api/Orders
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Order>>> GetOrders(string userId)
        {
            var userLg = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            return await _context.Orders.Include(i => i.User).Include(i => i.Coupons)
                .Include(i => i.OrderDetails).ThenInclude(i=>i.Product)
                .Include(i=>i.OrderDetails).ThenInclude(i=>i.OrderdetailToppingList)                
                .Where(i => i.UserId == userLg.Id).OrderByDescending(i=>i.Id)
                .ToListAsync();
        }
        

        [HttpPost]
        public async Task<ActionResult<Order>> PostOrder(Order order)
        {
            var userLg = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == order.UserId || p.FacebookUserId == order.UserId || p.GoogleUserId == order.UserId);
            

            var codeOrder = RandomCodeOrder();
           
            order.DeliveryTime = Convert.ToDateTime(order.DeliveryTime.ToString());
            order.OrderDate = DateTime.Now;
            order.Code = codeOrder;
            order.UserId = userLg.Id;

            //var addOrder = new Order()
            //{
            //   Code=codeOrder,
            //};

            _context.Orders.Add(order);
            _context.SaveChanges();

            //tìm giỏ hàng ủa khách
            var listCartUser = await _context.Carts.Where(i => i.UserId == userLg.Id).ToListAsync();
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

                    var lstTopping = await _context.CartNToppings.Include(p => p.Toppings).Where(p => p.CartId == item.Id).ToListAsync();

                    if (lstTopping.Any())
                    {
                        //thêm topping nếu trong sản phẩmm có
                        var exitOderDetail = _context.OrderDetails.SingleOrDefault(p => p.Code == orderDetails.Code);
                        foreach (var itemTopping in lstTopping)
                        {
                            var orderDtTopping = new OrderDetailNTopping()
                            {
                                OrderDetailId = exitOderDetail.Id,
                                ToppingsId = itemTopping.ToppingsId,
                                Status = true
                            };

                            _context.OrderDetailsNToppings.Add(orderDtTopping);
                            _context.SaveChanges();

                        }

                        _context.CartNToppings.RemoveRange(lstTopping);
                    }
                }

                _context.Carts.RemoveRange(listCartUser);

                //if (order.CouponsId != 1)
                //{
                //    var coupons = _context.CouponCodes.SingleOrDefault(i=>i.Id == order.CouponsId);
                //    if(coupons.Discount>1000)
                //    {
                //        userLg.Point = Convert.ToInt32((order.Total + order.DeliveryCharges - coupons.Discount)/10000);
                //    }
                //    else
                //    {
                //        userLg.Point = Convert.ToInt32((order.Total + order.DeliveryCharges)*coupons.Discount/10000);
                //    }
                //}
                //else
                //{
                //    userLg.Point = Convert.ToInt32((order.Total + order.DeliveryCharges)/10000);
                //}
                //_context.Users.Update(userLg);


                await _context.SaveChangesAsync();
            }
            await _hub.Clients.All.SendAsync("OrderMessage","Have a updated");

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
