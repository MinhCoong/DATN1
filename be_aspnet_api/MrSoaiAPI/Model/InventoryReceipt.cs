using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class InventoryReceipt
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public int SuppliersId { get; set; }
        [DefaultValue(0.0)]
        public double TotalValue { get; set; } = 0.0;
        public DateTime ReceiptDate { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
        public MrSoaiUser User { get; set; }
        public Supplier Suppliers { get; set; }
        public List<InventoryReceiptDetail> InventoryReceiptDetails { get; set;}
    }
}
