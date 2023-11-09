using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Data;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;
using Microsoft.AspNetCore.Authorization;
using System.Security.Principal;
using System.Security.Claims;
using System.Net.WebSockets;

namespace MrSoaiAPI.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("/[area]/v1/api/news")]
    [ApiController]
    
    public class NewsController : ControllerBase
    {
        private readonly MrSoaiAPIContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly IImageHandler _imageHandler;
        public NewsController(MrSoaiAPIContext context, IWebHostEnvironment hostEnvironment, IImageHandler imageHandler)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
            _imageHandler = imageHandler;
        }
        [HttpGet("/newimages/{imageName}")]
        public IActionResult Get(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\news");

            Byte[] b = System.IO.File.ReadAllBytes(imagesFolderPath + "\\" + imageName);   // You can use your own method over here.         
            return File(b, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("Folderpath")]
        public IActionResult GetFolderPath()
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images\\news");
            return Ok(imagesFolderPath);
        }
        // GET: api/News
        [Authorize(Roles = "Admin,Staff")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<News>>> GetNews()
        {
            return await _context.News.Where(i=>i.Status==true).Include(p => p.User).ToListAsync();
        }

        // GET: api/News/5
        [Authorize(Roles = "Admin")]
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
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<News>> PostNews([FromForm] News news)
        {
            var user = await _context.Users.FirstOrDefaultAsync(c => c.Id== news.UserId);
            if(user == null)
            {
                return BadRequest("Not found user");
            }
            var imageName = await _imageHandler.UploadImageNews(news.ImageFile);
            var newNews = new News
            {
                UserId = user.Id,
                Title = news.Title,
                NewsDate = news.NewsDate,
                Description = news.Description,
                Image = imageName,
                Status = true
            };

            _context.News.Add(newNews);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetNews", new { id = newNews.Id }, newNews);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutNews(int id, [FromForm] News news)
        {
            var update = await _context.News.FindAsync(id);

            if (news.ImageFile != null)
            {
                var imageName = await _imageHandler.UploadImageNews(news.ImageFile);
                update.UserId = news.UserId;
                update.Description = news.Description;
                update.Title = news.Title;
                update.Image = imageName;
                update.NewsDate = news.NewsDate;
            }
            else
            {
                update.UserId = news.UserId;
                update.Description = news.Description;
                update.Title = news.Title;
                update.NewsDate = news.NewsDate;
            }

            await _context.SaveChangesAsync();

            return NoContent();
        }
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteNews(int id)
        {
            var news = await _context.News.FindAsync(id);
            if (news == null)
            {
                return NotFound();
            }

            news.Status = false;
            _context.Entry(news).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }

            catch (DbUpdateConcurrencyException e)
            {
                Console.WriteLine(e);

            }
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
