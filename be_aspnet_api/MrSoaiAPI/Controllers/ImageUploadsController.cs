using Microsoft.AspNetCore.Mvc;
using MrSoaiAPI.Data;

namespace MrSoaiAPI.Controllers
{
    //    [Route("api/[controller]")]
    //    [ApiController]
    //    public class TestsController : ControllerBase
    //    {
    //        private readonly IImageHandler _imageHandler;

    //        public TestsController(IImageHandler imageHandler) {
    //            _imageHandler=imageHandler;
    //        }

    //        [HttpPost]
    //        public async Task<IActionResult> UploadImage(IFormFile formFile)
    //        {
    //            return await _imageHandler.UploadImage(formFile);
    //        }
    //    }

    [Route("v1/api/[controller]")]
    [ApiController]
    public class ImageUploadsController : ControllerBase
    {
        private readonly IWebHostEnvironment _hostEnvironment;
        private readonly MrSoaiAPIContext _context;

        public ImageUploadsController(IWebHostEnvironment hostEnvironment, MrSoaiAPIContext context)
        {
            _hostEnvironment = hostEnvironment;
            _context = context;

        }

        [HttpGet("{imageName}")]
        public IActionResult Get(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images//products");
            string imagePath = Path.Combine(imagesFolderPath, imageName);

            if (!System.IO.File.Exists(imagePath))
            {
                return NotFound();
            }

            Byte[] file = System.IO.File.ReadAllBytes(imagePath);
            return File(file, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("CategoryImage/{imageName}")]
        public IActionResult GetCategoryImage(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images//category_images");
            string imagePath = Path.Combine(imagesFolderPath, imageName);

            if (!System.IO.File.Exists(imagePath))
            {
                return NotFound();
            }

            Byte[] file = System.IO.File.ReadAllBytes(imagePath);
            return File(file, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("CustomerImage/{imageName}")]
        public IActionResult GetCustomerImage(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images//customers");
            string imagePath = Path.Combine(imagesFolderPath, imageName);

            if (!System.IO.File.Exists(imagePath))
            {
                return NotFound();
            }

            Byte[] file = System.IO.File.ReadAllBytes(imagePath);
            return File(file, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("CouponsImage/{imageName}")]
        public IActionResult GetCouponsImage(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images//coupons");
            string imagePath = Path.Combine(imagesFolderPath, imageName);

            if (!System.IO.File.Exists(imagePath))
            {
                return NotFound();
            }

            Byte[] file = System.IO.File.ReadAllBytes(imagePath);
            return File(file, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("SliderImage/{imageName}")]
        public IActionResult GetSliderImage(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images//sliders");
            string imagePath = Path.Combine(imagesFolderPath, imageName);

            if (!System.IO.File.Exists(imagePath))
            {
                return NotFound();
            }

            Byte[] file = System.IO.File.ReadAllBytes(imagePath);
            return File(file, "image/" + imageName.Split(".")[1]);
        }

        [HttpGet("NewsImage/{imageName}")]
        public IActionResult GetNewsImage(string imageName)
        {
            string imagesFolderPath = Path.Combine(_hostEnvironment.WebRootPath, "images//news");
            string imagePath = Path.Combine(imagesFolderPath, imageName);

            if (!System.IO.File.Exists(imagePath))
            {
                return NotFound();
            }

            Byte[] file = System.IO.File.ReadAllBytes(imagePath);
            return File(file, "image/" + imageName.Split(".")[1]);
        }
    }
}







