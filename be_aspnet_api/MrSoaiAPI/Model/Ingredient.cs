using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    //Nguyên liệu
    public class Ingredient
    {
        public int Id { get; set; }
        public string IngredientName { get; set; }
        public string Unit { get; set; }
        public double Quantity { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}
