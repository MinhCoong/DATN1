using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class Notification
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public string Title { get; set; }
        public string Body { get; set; }
        public DateTime CreatedAt { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
