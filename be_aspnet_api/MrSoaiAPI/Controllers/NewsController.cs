using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Controllers
{
    [Route("v1/api/[controller]")]
    [ApiController]
    public class NewsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;

        public NewsController(MrSoaiAPIContext context)
        {
            _context = context;
        }

        // GET: api/News
        [HttpGet]
        public async Task<ActionResult<IEnumerable<News>>> GetNews()
        {
            return await _context.News.Where(s => s.Status == true).ToListAsync();
        }

        // GET: api/News/5
        [HttpGet("{id}")]
        public async Task<ActionResult<News>> GetNews(int id)
        {
            var news = await _context.News.FindAsync(id);

            if (news == null)
            {
                return NotFound();
            }

            return news;
        }

        [HttpGet("getSlider")]
        public async Task<ActionResult<IEnumerable<Slider>>> GetSlider()
        {
            return await _context.Sliders.Where(s => s.Status == true).ToListAsync();
        }
    }
}
