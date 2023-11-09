using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Runtime.InteropServices;

namespace MrSoaiAPI.Model
{
    public class Price
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        [Required]
        public int SizeId { get; set; }
        [Required]
        public double PriceOfProduct { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public Product Product { get; set; }
        public Size Size { get; set; }
    }
}
