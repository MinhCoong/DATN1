namespace MrSoaiAPI.Interface
{
    public interface IImageWriter
    {
        Task<string> UploadImage(IFormFile file);

        Task<string> UploadImageProduct(IFormFile file);
        Task<string> UploadImageNews(IFormFile file);
        Task<string> UploadImageCoupon(IFormFile file);

        Task<string> UploadImageSlider(IFormFile file);

        Task<bool> DeleteImage(String filePath);
    }
}
