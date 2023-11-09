using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace MrSoaiAPI.Model
{
    public class Address
    {

        public int Id { get; set; }
        public string UserId { get; set; }
        public MrSoaiUser User { get; set; }
        public string AddrressValue { get; set; }
        public string NameAddress { get; set; }
        public string Description { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
