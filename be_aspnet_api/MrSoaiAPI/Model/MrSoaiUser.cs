using Microsoft.AspNetCore.Identity;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model
{
    public class MrSoaiUser : IdentityUser
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string AuthenPhoneNumberId { get; set; }
        public string FacebookUserId { get; set; }
        public string GoogleUserId { get; set; }
        public int Point { get; set; }
        public string Avatar { get; set; }
        public string Sex { get; set; }
        public DateTime DateOfBirth { get; set; }
        [NotMapped]
        public IFormFile ImageFile { get; set; }
        public DateTime RegisterDatetime { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;   
        public List<Address> Addresses { get; set; }
       
    }
}
