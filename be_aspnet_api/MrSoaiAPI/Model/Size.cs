using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace MrSoaiAPI.Model
{
    public class Size
    {
        public int Id { get; set; }

        public string SizeName { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
