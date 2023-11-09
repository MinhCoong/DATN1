namespace MrSoaiAPI.Model
{
    public class AddCart
    {
        public string UserId { get; set; }
        public int ProductId { set; get; }
        public int Quantity { set; get; }
        public int SizeId { set; get; }
        public string Description { set; get; }
        public double PriceProduct { get; set; }
        public List<int> ToppingSelect { get; set; }
    }
}
