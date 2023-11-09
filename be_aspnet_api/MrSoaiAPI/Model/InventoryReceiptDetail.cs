using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class InventoryReceiptDetail
    {
        public int Id { get; set; }    
        public int IngredientsId { get; set; }    
        public int InventoryReceiptsId { get; set; }
        public double Quantity { get; set; }
        public double PurchasePrice { get; set; }
        public double Subtotal { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public Ingredient Ingredients { get; set; }
        public InventoryReceipt InventoryReceipts { get; set; }
    }
}
