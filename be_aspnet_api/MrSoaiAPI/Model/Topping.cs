using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model
{
    public class Topping
    {
        public int Id { get; set; }
        public string ToppingName { get; set; }
        public double Price { get; set; }
        public string Image { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;

    }

}
