using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class CartsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public CartsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/Carts
        [HttpGet("{userId}")]
        public async Task<IActionResult> GetCart(string userId)
        {
            var User = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            var cart = await _context.Carts.Include(p => p.Product).Include(p => p.Size).Include(p => p.CartNToppings).ThenInclude(p => p.Toppings).Where(p => p.UserId == User.Id).ToListAsync();

            return Ok(cart);
        }

        // POST: api/Carts
        [HttpPost("AddToCart")]
        public async Task<ActionResult<Cart>> AddToCart([FromBody] AddCart cart)
        {
            var UserLg = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == cart.UserId || p.FacebookUserId == cart.UserId || p.GoogleUserId == cart.UserId);
           
            if (UserLg == null)
            {
                return BadRequest();
            }

            string x = RandomCodeOrder();
            var item = new Cart()
            {
                CodeOfCart= x,
                UserId = UserLg.Id,
                ProductId = cart.ProductId,
                SizeId = cart.SizeId,
                Quantity = cart.Quantity,
                PriceProduct = cart.PriceProduct,
                Desciption = cart.Description,
                Status = true
            };

            _context.Carts.Add(item);
            _context.SaveChanges();


            if (cart.ToppingSelect.Any())
            {
                var getCart =  _context.Carts.SingleOrDefault(p => p.CodeOfCart == item.CodeOfCart);
                for (int i = 0; i < cart.ToppingSelect.Count; i++)
                {
                    var toppingCheck = await _context.Toppings.SingleOrDefaultAsync(p => p.Id == cart.ToppingSelect[i]);
                    var newToppingNCart = new CartNTopping()
                    {
                        CartId = getCart.Id,
                        ToppingsId = toppingCheck.Id,
                        Status = true
                    };
                    _context.CartNToppings.Add(newToppingNCart);
                }
                await _context.SaveChangesAsync();
            }


            return Ok();
        }

        // DELETE: api/Carts/5
        [HttpDelete("Delete")]
        public async Task<IActionResult> DeleteCart(int? Id, string userId)
        {
            if (Id != null)
            {
                var item = await _context.Carts.FindAsync(Id);
                if (item != null)
                {
                    var listToppingOfProduc = await _context.CartNToppings.Where(p => p.CartId == item.Id).ToListAsync();
                    if (listToppingOfProduc.Any())
                    {
                        _context.CartNToppings.RemoveRange(listToppingOfProduc);
                    }

                    _context.Carts.Remove(item);
                }
            }
            else
            {
                var user = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
                var itemCartProduct = await _context.Carts.Where(p => p.UserId == user.Id).ToListAsync();
                if (itemCartProduct.Any())
                {
                    foreach (var item in itemCartProduct)
                    {
                        var listToppingOfProduc = await _context.CartNToppings.Where(p => p.CartId == item.Id).ToListAsync();
                        if (listToppingOfProduc.Any())
                        {
                            _context.CartNToppings.RemoveRange(listToppingOfProduc);
                        }
                    }
                    _context.Carts.RemoveRange(itemCartProduct);
                }
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        public bool AreListsEqual<Topping>(List<Topping> list1, List<int> list2)
        {
            if (list1.Count != list2.Count) return false;
            for (int i = 0; i < list2.Count; i++)
            {
                Topping topping1 = list1[i];
                int topping2 = list2[i];
                if (!topping1.Equals(topping2))
                {
                    return false;
                }
            }
            return true;
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

            } while (_context.Carts.SingleOrDefault(i => i.CodeOfCart == Code) != null);

            return Code;
        }


    }
}
