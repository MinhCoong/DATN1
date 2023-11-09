using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model
{
    public class Slider
    {
        public int Id { get; set; }
    
        public string ImageSlider { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        public DateTime DateAdd { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
