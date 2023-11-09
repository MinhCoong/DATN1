using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class OrderDetailNTopping
    {
        public int Id { get; set; }
        public int ToppingsId { get; set; }
        public Topping Toppings { get; set; }
        public int OrderDetailId { get; set; }
        public OrderDetail OrderDetail { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;

    }
}
