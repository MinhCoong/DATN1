using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class Quantum
    {
        public int Id { get; set; }
        public string ProductName { get; set; }//Khong duoc trung ten
        public int IngredientsId { get; set; }
        public double Quantity { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public Ingredient Ingredients { get; set; }
    }
}
