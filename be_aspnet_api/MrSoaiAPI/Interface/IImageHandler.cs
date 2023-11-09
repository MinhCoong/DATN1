using Microsoft.AspNetCore.Mvc;

namespace MrSoaiAPI.Interface
{
    public interface IImageHandler
    {
        Task<IActionResult> UploadImage(IFormFile file);
        Task<string> UploadImageProduct(IFormFile file);
        Task<string> UploadImageNews(IFormFile file);
        Task<string> UploadImageCoupon(IFormFile file);
        Task<string> UploadImageSlider (IFormFile file);
        Task<bool> DeleteImage (string filePath);
    }
}
