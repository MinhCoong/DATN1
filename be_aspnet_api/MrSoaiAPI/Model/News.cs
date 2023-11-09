using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model
{
    public class News
    {
        public int Id { get; set; }
    
        public string UserId { get; set; }
    
        public string Title { get; set; }
    
        public DateTime NewsDate { get; set; }
        public string Image { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        public string Description { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public  MrSoaiUser User { get; set; }
    }
}
