using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class Supplier
    {
        public int Id { get; set; }
        public string SupplierName { get; set; }
        public string SupplierAddress { get; set; }
        public string SupplierPhoneNumber { get; set; }
        public string SupplierEmail { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;
    }
}