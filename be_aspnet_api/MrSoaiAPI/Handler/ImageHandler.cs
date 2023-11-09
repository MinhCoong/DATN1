using Microsoft.AspNetCore.Mvc;
using MrSoaiAPI.Interface;

namespace MrSoaiAPI.Handler
{
    public class ImageHandler : IImageHandler
    {
        private readonly IImageWriter _imageWriter;

        public ImageHandler(IImageWriter imageWriter)
        {
            _imageWriter = imageWriter;
        }
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            var result = await _imageWriter.UploadImage(file);
            return new ObjectResult(result);
        }

        public async Task<string> UploadImageProduct(IFormFile file)
        {
            var result = await _imageWriter.UploadImageProduct(file);
            return result;
        }
        public async Task<string> UploadImageSlider(IFormFile file)
        {
            var result = await _imageWriter.UploadImageSlider(file);
            return result;
        }
        public async Task<bool> DeleteImage(string filePath)
        {
            var result = await _imageWriter.DeleteImage(filePath);
            return result;
        }
        public async Task<string> UploadImageNews(IFormFile file)
        {
            var result = await _imageWriter.UploadImageNews(file);
            return result;
        }
        public async Task<string> UploadImageCoupon(IFormFile file)
        {
            var result = await _imageWriter.UploadImageCoupon(file);
            return result;
        }
    }
}
