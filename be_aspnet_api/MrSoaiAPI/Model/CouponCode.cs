using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model
{
    public class CouponCode
    {
        public int Id { get; set; }        
        public string UserId { get; set; }
        public MrSoaiUser User { get; set; } 
        public string Title { get; set; }
        public string Code { get; set; }
        [DefaultValue(0)]
        public double Discount { get; set; } = 0;
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        [DefaultValue(0)]
        public int Point { get; set; } = 0;
        [DefaultValue(0)]
        public int MinimumQuantity { get; set; } = 0;
        [DefaultValue(0)]
        public double MinimumTotla { get; set; } = 0;
        public string Image { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
       
    }
}
