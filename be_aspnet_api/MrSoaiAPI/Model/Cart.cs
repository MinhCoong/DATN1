using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class Cart
    {
        public int Id { get; set; }
        public string CodeOfCart { get; set; }
        public string UserId { get; set; }
        public MrSoaiUser User { get; set; }
        public int ProductId { get; set; }
        public Product Product { get; set; }
        public int SizeId { get; set; }
        public Size Size { get; set; }
        [DefaultValue(1)]
        public int Quantity { get; set; } = 1;
        public double PriceProduct { get; set; }
        public string Desciption { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        //[IgnoreDataMember]
        public List<CartNTopping> CartNToppings { get; set; }
    }  
}
