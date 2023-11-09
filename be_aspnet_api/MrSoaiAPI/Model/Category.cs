using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model
{
    public class Category
    {
        public int Id { get; set; }
        public string CategoryName { get; set; }
        public string Image { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public List<Product> Products { get; set; }
        public List<Topping> Toppings { get; set; }
    }
}
