using MrSoaiAPI.Interface;
using System.Text;

namespace MrSoaiAPI.Units
{
    public class ImageWriter : IImageWriter
    {
        public async Task<string> UploadImage(IFormFile file)
        {
            if(CheckIfImageFile(file))
            {
                return await WriteFile(file);
            }
            return "Invalid image file";
        }

        private static async Task<string> WriteFile(IFormFile file)
        {
            string fileName;
            try
            {
                var extension = new StringBuilder(".")
                    .Append(file.FileName.Split(".")[file.FileName.Split(".").Length - 1]);
                fileName = new StringBuilder(Guid.NewGuid().ToString()).Append(extension).ToString();
                var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot\\images", fileName);

                using (var bits = new FileStream(path, FileMode.Create))
                    await file.CopyToAsync(bits);
            }catch (Exception e)
            {
                return e.Message;
            }

            return fileName;
        }

        private static async Task<string> WriteFileProduct(IFormFile file)
        {
            string fileName;
            try
            {
                var extension = new StringBuilder(".")
                    .Append(file.FileName.Split(".")[file.FileName.Split(".").Length - 1]);
                fileName = new StringBuilder(Guid.NewGuid().ToString()).Append(extension).ToString();
                var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot\\images\\products", fileName);

                using (var bits = new FileStream(path, FileMode.Create))
                    await file.CopyToAsync(bits);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return fileName;
        }
        private static async Task<string> WriteFileNews(IFormFile file)
        {
            string fileName;
            try
            {
                var extension = new StringBuilder(".")
                    .Append(file.FileName.Split(".")[file.FileName.Split(".").Length - 1]);
                fileName = new StringBuilder(Guid.NewGuid().ToString()).Append(extension).ToString();
                var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot\\images\\news", fileName);

                using (var bits = new FileStream(path, FileMode.Create))
                    await file.CopyToAsync(bits);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return fileName;
        }
        private static async Task<string> WriteFileCoupon(IFormFile file)
        {
            string fileName;
            try
            {
                var extension = new StringBuilder(".")
                    .Append(file.FileName.Split(".")[file.FileName.Split(".").Length - 1]);
                fileName = new StringBuilder(Guid.NewGuid().ToString()).Append(extension).ToString();
                var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot\\images\\coupons", fileName);

                using (var bits = new FileStream(path, FileMode.Create))
                    await file.CopyToAsync(bits);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return fileName;
        }
       

        private static async Task<string> WriteFileSlider(IFormFile file)
        {
            string fileName;
            try
            {
                var extension = new StringBuilder(".")
                    .Append(file.FileName.Split(".")[file.FileName.Split(".").Length - 1]);
                fileName = new StringBuilder(Guid.NewGuid().ToString()).Append(extension).ToString();
                var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot\\images\\sliders", fileName);

                using (var bits = new FileStream(path, FileMode.Create))
                    await file.CopyToAsync(bits);
            }
            catch (Exception e)
            {
                return e.Message;
            }

            return fileName;
        }


        public async Task<bool> DeleteImage(string filePath)
        {
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
                return await Task.FromResult(true);
            }
            else
            {
                return await Task.FromResult(false);
            }
        }

        private bool CheckIfImageFile(IFormFile file)
        {
            byte[] fileBytes;
            using (var ms = new MemoryStream())
            {
                file.CopyTo(ms);
                fileBytes = ms.ToArray();
            }
            return WriteHelper.GetImageFormat(fileBytes).ToString() != WriteHelper.ImageFotmat.unknown.ToString();
        }
        public async Task<string> UploadImageProduct(IFormFile file)
        {
            if (CheckIfImageFile(file))
            {
                return await WriteFileProduct(file);
            }
            return "Invalid image file";
        }
        public async Task<string> UploadImageNews(IFormFile file)
        {
            if (CheckIfImageFile(file))
            {
                return await WriteFileNews(file);
            }
            return "Invalid image file";
        }
        public async Task<string> UploadImageCoupon(IFormFile file)
        {
            if (CheckIfImageFile(file))
            {
                return await WriteFileCoupon(file);
            }
            return "Invalid image file";
        }
        public async Task<string> UploadImageSlider(IFormFile file)
        {
            if (CheckIfImageFile(file))
            {
                return await WriteFileSlider(file);
            }
            return "Invalid image file";
        }
    }
}
