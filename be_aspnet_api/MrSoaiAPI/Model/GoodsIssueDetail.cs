using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class GoodsIssueDetail
    {
        public int Id { get; set; }
        public int IngredientsId { get; set; }
        public int GoodsIssueId { get; set; }
        public double Quantity { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public Ingredient Ingredients { get; set;}
        public GoodsIssue GoodsIssues { get; set;}
    }
}
