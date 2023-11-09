using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MrSoaiAPI.Model.Authentication
{
    public class RegisterInsiderModel
    {
        [Required]
        public string FirstName { get; set; }

        [Required]
        public string LastName { get; set; }

        public string PhoneNumber { set; get; }

        [Required]
        public string UserName { set; get; }

        [Required]
        public string Password { set; get; }

        [NotMapped]
        [Required]
        [Compare("Password")]
        public string ConfirmPassword { get; set; }

    }

    public class RegisterCustomerModel
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string AuthenPhoneNumberId { get; set; }

        public string PhoneNumber { get; set; }

        public string FacebookUserId { get; set; }

        public string GoogleUserId { get; set;}

        public string Email { get; set; }

        public string Avatar { get; set; }

    }
}
