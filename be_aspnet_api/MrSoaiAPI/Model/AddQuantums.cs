namespace MrSoaiAPI.Model
{
    public class AddQuantums
    {
        public string ProductName { get; set; }
        public List<IngredentAndQuantity> ListIngredientAndQuantity { get; set; }
    }

    public class IngredentAndQuantity
    {
        public int IngredientId { get; set; }
        public double Quantity { get; set; }
    }
}
