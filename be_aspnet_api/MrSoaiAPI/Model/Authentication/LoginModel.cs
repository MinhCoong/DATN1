using System.ComponentModel.DataAnnotations;

namespace MrSoaiAPI.Model.Authentication
{
    public class LoginInsiderModel
    {
        [Required]
        public string UserName { get; set; }

        [Required]
        public string Password { get; set; }
    }
    
}
