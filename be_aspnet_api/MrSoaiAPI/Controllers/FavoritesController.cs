using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class FavoritesController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public FavoritesController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/Favorites
        [HttpGet("{userId}")]
        public async Task<ActionResult<IEnumerable<Product>>> GetFavorites(string userId)
        {
            var UserLg = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == userId || p.FacebookUserId == userId || p.GoogleUserId == userId);
            var favorite= await _context.Favorites.Where(i => i.UserId == UserLg.Id).ToListAsync();
            List<Product> products = new();
            foreach (var item in favorite)
            {
                var prod = await _context.Products.Where(i=>i.Status==true).Include(p => p.Category).Include(p => p.Prices).ThenInclude(i => i.Size).SingleOrDefaultAsync(i=>i.Id==item.ProductId);
                if (prod != null)
                {
                    products.Add(prod);
                }
            }
            return products;
        }

        [HttpPost]
        public async Task<ActionResult<Favorite>> PostFavorite(Favorite favorite)
        {
            var UserLg = await _context.Users.SingleOrDefaultAsync(p => p.AuthenPhoneNumberId == favorite.UserId || p.FacebookUserId == favorite.UserId || p.GoogleUserId == favorite.UserId);
            if (UserLg == null)
            {
                return BadRequest();
            }

            var productOfFavorite = await _context.Favorites.SingleOrDefaultAsync(p => p.ProductId == favorite.ProductId && p.UserId == UserLg.Id);
            if (productOfFavorite == null)
            {
                var item = new Favorite()
                {
                    UserId = UserLg.Id,
                    ProductId = favorite.ProductId,
                    Status = true,
                };
                _context.Favorites.Add(item);
            }
            else
            {
                _context.Favorites.Remove(productOfFavorite);
            }

            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}
