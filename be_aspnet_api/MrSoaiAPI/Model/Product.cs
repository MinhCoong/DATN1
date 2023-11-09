using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace MrSoaiAPI.Model
{
    public class Product
    {
        public int Id { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public int CategoryId { get; set; }
        public string Image { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public virtual Category Category { get; set; }
        [IgnoreDataMember]
        public List<Price> Prices { get; set; }


    }
}
