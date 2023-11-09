using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class GoodsIssue
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public DateTime CheckDatime { get; set; }
        public string Description { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public MrSoaiUser User { get; set; }
        public List<GoodsIssueDetail> GoodsIssueDetails { get; set; }
    }
}
