using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;
using MrSoaiAPI.Model.Authentication;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/[controller]")]
    [ApiController]
    public class StatisticsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly RoleManager<IdentityRole> _roleManager;

        public StatisticsController(MrSoaiAPIContext context, RoleManager<IdentityRole> roleManager)
        {
            _context = context;
            _roleManager = roleManager;
        }

        [HttpGet("GetSalesRevenue")]
        public IActionResult GetSalesRevenue(DateTime startDate, DateTime endDate)
        {
            var orders = _context.Orders
                .Where(o => o.OrderDate >= startDate && o.OrderDate <= endDate)
                .ToList();

            double totalRevenue = orders.Sum(o => o.Total);

            var result = new
            {
                StartDate = startDate,
                EndDate = endDate,
                TotalRevenue = totalRevenue
            };

            return Ok(result);
        }

        [HttpGet("GetRevenue")]
        public IActionResult GetRevenue(int i)
        {
            DateTime date = DateTime.Now;
            List<Order> orders = new();
            switch (i)
            {
                case 0:
                    {
                        orders = _context.Orders
                            .Where(i => i.OrderDate.Month == date.Month)
                            .GroupBy(i => i.OrderDate.Day).
                            Select(
                            a => new Order
                            {
                                Id = a.Key,
                                Total = a.Sum(i => i.Total)
                            }
                            ).ToList();
                    }
                    break;
                case 1:
                    {
                        orders = _context.Orders
                                         .Where(i => i.OrderDate.Year == date.Year)
                                         .GroupBy(i => i.OrderDate.Month)
                                         .Select(a => new Order
                                         {
                                             Id = a.Key,
                                             Total = a.Sum(i => i.Total)
                                         })
                                         .ToList();
                    }
                    break;
                case 2:
                    {
                        orders = _context.Orders
                         .GroupBy(i => i.OrderDate.Year).
                         Select(
                         a => new Order
                         {
                             Id = a.Key,
                             Total = a.Sum(i => i.Total)
                         }
                         ).ToList();
                    }
                    break;
            }

            return Ok(orders);
        }
          [HttpGet("GetProfit")]
        public IActionResult GetProfit(int i)
        {
            DateTime date = DateTime.Now;
            List<Order> orders = new();
            switch (i)
            {
                case 0:
                    {
                        orders = _context.Orders
                            .Where(i => i.OrderDate.Month == date.Month)
                            .GroupBy(i => i.OrderDate.Day).
                            Select(
                            a => new Order
                            {
                                Id = a.Key,
                                Total = a.Sum(i => i.Total) - _context.InventoryReceipts.Where(i => i.Status == true && i.ReceiptDate.Month == date.Month && i.ReceiptDate.Day == a.Key).Sum(i => i.TotalValue)
                            }
                            ).ToList();
                    }
                    break;
                case 1:
                    {
                        orders = _context.Orders
                                         .Where(i => i.OrderDate.Year == date.Year)
                                         .GroupBy(i => i.OrderDate.Month)
                                         .Select(a => new Order
                                         {
                                             Id = a.Key,
                                             Total = a.Sum(i => i.Total) - _context.InventoryReceipts
                                                 .Where(i => i.Status == true && i.ReceiptDate.Year == date.Year && i.ReceiptDate.Month == a.Key)
                                                 .Sum(i => i.TotalValue)
                                         })
                                         .ToList();
                    }
                    break;
                case 2:
                    {
                        orders = _context.Orders
                         .GroupBy(i => i.OrderDate.Year).
                         Select(
                         a => new Order
                         {
                             Id = a.Key,
                             Total = a.Sum(i => i.Total) - _context.InventoryReceipts.Where(i => i.Status == true && i.ReceiptDate.Year == a.Key).Sum(i => i.TotalValue)
                         }
                         ).ToList();
                    }
                    break;
            }

            return Ok(orders);
        }

       

        [HttpGet("GetSales")]
        public IActionResult GetSales(int i)
        {
            DateTime date = DateTime.Now;
            List<Order> orders = new();
            switch (i)
            {
                case 0:
                    {
                        orders = _context.OrderDetails.Include(i => i.Order).Include(i => i.Product)
                            .Where(i => i.Order.OrderDate.Month == date.Month)
                            .GroupBy(i => i.Order.OrderDate.Day).
                            Select(
                            a => new Order
                            {
                                Id = a.Key,
                                Total = a.Sum(i => i.Quantity)
                            }
                            ).ToList();
                    }
                    break;
                case 1:
                    {
                        orders = _context.OrderDetails.Include(i => i.Order).Include(i => i.Product)
                            .Where(i => i.Order.OrderDate.Year == date.Year)
                            .GroupBy(i => i.Order.OrderDate.Month).
                            Select(
                            a => new Order
                            {
                                Id = a.Key,
                                Total = a.Sum(i => i.Quantity)
                            }
                            ).ToList();
                    }
                    break;
                case 2:
                    {
                        orders = _context.OrderDetails.Include(i => i.Order).Include(i => i.Product)
                         .GroupBy(i => i.Order.OrderDate.Year).
                         Select(
                         a => new Order
                         {
                             Id = a.Key,
                             Total = a.Sum(i => i.Quantity)
                         }
                         ).ToList();
                    }
                    break;
            }

            return Ok(orders);
        }

        [HttpGet("NewCustommer")]
        public async Task<IActionResult> NewCustommer(int i)
        {
            var date = DateTime.Now;
            var roleId = await _roleManager.FindByNameAsync(UserRoles.Customer);

            switch (i)
            {
                case 0:
                    {
                        var user = await _context.UserRoles
                                    .Where(i => i.RoleId == roleId.Id)
                                    .Join(_context.Users, ur => ur.UserId, user => user.Id, (ur, user) => new { UserRole = ur, User = user })
                                    .Where(i => i.User.RegisterDatetime.Month == date.Month)
                                    .GroupBy(i => i.User.RegisterDatetime.Day)
                                    .Select(g => new
                                    {
                                        Total = g.Key,
                                        ListCustomer = g.Count(i => i.User.Status)
                                    })
                                    .ToListAsync();
                        return Ok(user);

                    }

                case 1:
                    {
                        var user = await _context.UserRoles
                                    .Where(i => i.RoleId == roleId.Id)
                                    .Join(_context.Users, ur => ur.UserId, user => user.Id, (ur, user) => new { UserRole = ur, User = user })
                                    .Where(i => i.User.RegisterDatetime.Year == date.Year)
                                    .GroupBy(i => i.User.RegisterDatetime.Month)
                                    .Select(g => new
                                    {
                                        Total = g.Key,
                                        ListCustomer = g.Count(i => i.User.Status)
                                    })
                                    .ToListAsync();

                        return Ok(user);

                    }

                case 2:
                    {
                        var user = await _context.UserRoles
                                    .Where(i => i.RoleId == roleId.Id)
                                    .Join(_context.Users, ur => ur.UserId, user => user.Id, (ur, user) => new { UserRole = ur, User = user })
                                    .GroupBy(i => i.User.RegisterDatetime.Year)
                                    .Select(g => new
                                    {
                                        Total = g.Key,
                                        ListCustomer = g.Count(i => i.User.Status)
                                    })
                                    .ToListAsync(); ;
                        return Ok(user);

                    }
                default: return Ok();

            }

        }


    }
}
