using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class ToppingNCategory
    {
        public int Id { get; set; }
        public int ToppingsId { get; set; }
        public Topping Toppings { get; set; }
        public int CategoryId { get; set; }
        public Category Category { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
