using System.ComponentModel;

namespace MrSoaiAPI.Model
{
    public class CartNTopping
    {
        public int Id { get; set; }
        public int ToppingsId { get; set; }
        public Topping Toppings { get; set; }
        public int CartId { get; set; }
        public Cart Cart { get; set; }
        [DefaultValue(true)]
        public bool Status { get; set; } = true;


        public override bool Equals(object obj)
        {
            if (obj == null || GetType() != obj.GetType())
                return false;

            int otherCart = (int)obj;
            return ToppingsId == otherCart; // So sánh các thuộc tính khác nếu cần thiết
        }

        public override int GetHashCode()
        {
            return ToppingsId.GetHashCode(); // Xác định giá trị băm cho phần tử, dựa trên thuộc tính Name
        }
    }
}
