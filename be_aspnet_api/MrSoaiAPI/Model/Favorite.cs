using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class Favorite
    {
        public int Id { get; set; }

        public string UserId { get; set; }
     

        public MrSoaiUser User { get; set; }

        public int ProductId { get; set; }


        public Product Product { get; set; }

        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
