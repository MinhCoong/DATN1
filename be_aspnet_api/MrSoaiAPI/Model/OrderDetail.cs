using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class OrderDetail
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public int OrderId { get; set; }
        public Order Order { get; set; }
        public int ProductId { get; set; }
        public Product Product { get; set; }
        public int SizeId { get; set; }
        public Size Size { get; set; }
        [DefaultValue(1)]
        public int Quantity { get; set; } = 1;
        [DefaultValue(0)]
        public double Price { get; set; } = 0;
        public string Desciption { get; set; }
        [DefaultValue(0)] 
        public double Subtotal { set; get; } = 0;
        public List<OrderDetailNTopping> OrderdetailToppingList { get; set; }
    }
}
