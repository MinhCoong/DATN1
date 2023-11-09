using System.Text;

namespace MrSoaiAPI.Units
{
    public class WriteHelper
    {
        public enum ImageFotmat
        {
            bmp,
            jpeg,
            gif,
            tiff,
            png,
            unknown
        }
        internal static object GetImageFormat(byte[] fileBytes)
        {
            var bmp = Encoding.ASCII.GetBytes("BM");
            var gif = Encoding.ASCII.GetBytes("GIF");
            var png = new byte[] { 137, 80, 78, 71 };//header bytes
            var tiff = new byte[] {73, 73, 42};//header bytes
            var tiff2 = new byte[] { 77, 77, 42};//header bytes
            var jpeg = new byte[] { 255, 216, 255, 224 };//header bytes
            var jpeg2 = new byte[] { 255, 216, 255, 225 };//header bytes

            if (bmp.SequenceEqual(fileBytes.Take(bmp.Length))) return ImageFotmat.bmp;
            if (gif.SequenceEqual(fileBytes.Take(gif.Length))) return ImageFotmat.gif;
            if (png.SequenceEqual(fileBytes.Take(png.Length))) return ImageFotmat.png;
            if (tiff.SequenceEqual(fileBytes.Take(tiff.Length))) return ImageFotmat.tiff;
            if (tiff2.SequenceEqual(fileBytes.Take(tiff2.Length))) return ImageFotmat.tiff;
            if (jpeg.SequenceEqual(fileBytes.Take(jpeg.Length))) return ImageFotmat.jpeg;
            if (jpeg2.SequenceEqual(fileBytes.Take(jpeg2.Length))) return ImageFotmat.jpeg;

            return ImageFotmat.unknown;
        }

    }
}
