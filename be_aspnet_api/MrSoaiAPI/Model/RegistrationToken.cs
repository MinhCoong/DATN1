using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class RegistrationToken
    {
        public int Id { set; get; }
        public string DeviceToken { set; get; }
        public string UserId { set; get; }
        public MrSoaiUser User { set; get; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
