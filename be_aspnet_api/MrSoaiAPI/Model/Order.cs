using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class Order
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string UserId { get; set; }
        public MrSoaiUser User { get; set; }
        public int CouponsId { get; set; }
        public CouponCode Coupons { get; set; }
        public DateTime OrderDate { get; set; }
        public string ConsigneePhoneNumber { get; set; }
        public string ConsigneeName { get; set; }
        public string DeliveryMethod { set; get; }  
        public DateTime DeliveryTime { get; set; }
        public string ConsigneeAddress { get; set; }
        public string PaymentMethod { get; set; }
        [DefaultValue(0)]
        public double Total { get; set; } = 0; 
        [DefaultValue(0)]
        public double DeliveryCharges { get; set; } = 0;
        [DefaultValue(0)]
        public int OrderStatus { get; set; } = 0;
        public List<OrderDetail> OrderDetails { get; set; }
    }
}
