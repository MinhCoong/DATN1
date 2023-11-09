using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MrSoaiAPI.Model;

namespace MrSoaiAPI.Data
{
    public class MrSoaiAPIContext:IdentityDbContext<MrSoaiUser>
    {
        public MrSoaiAPIContext(DbContextOptions<MrSoaiAPIContext> opions):base(opions) { }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            // Bỏ tiền tố AspNet của các bảng: mặc định
            foreach (var entityType in builder.Model.GetEntityTypes())
            {
                var tableName = entityType.GetTableName();
                if (tableName.StartsWith("AspNet"))
                {
                    entityType.SetTableName(tableName.Substring(6));
                }
            }
        }
        public DbSet<Address> Addresses { get; set; }
        public DbSet<Cart> Carts { get; set; }
        public DbSet<CartNTopping> CartNToppings { get; set; }
        public DbSet<Category> Categorys { get; set; }
        public DbSet<CouponCode> CouponCodes { get; set; }
        public DbSet<Favorite> Favorites { get; set; }
        public DbSet<Ingredient> Ingredients { get; set; }
        public DbSet<GoodsIssueDetail> GoodsIssueDetails { get; set; }
        public DbSet<GoodsIssue> GoodsIssues { get; set; }
        public DbSet<InventoryReceipt> InventoryReceipts { get; set; }
        public DbSet<InventoryReceiptDetail> InventoryReceiptDetails { get; set; }
        public DbSet<News> News { get; set; }
        public DbSet<Notification> Notifications { get; set; }  
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderDetail> OrderDetails { get; set; }
        public DbSet<OrderDetailNTopping> OrderDetailsNToppings { get; set; }  
        public DbSet<Price> Prices { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Quantum> Quantums { get; set; }    
        public DbSet<RegistrationToken> RegistrationTokens { get; set; }  
        public DbSet<Size> Sizes { get; set; }
        public DbSet<Slider> Sliders { get; set; }
        public DbSet<Supplier> Suppliers { get; set; }
        public DbSet<Topping> Toppings { get; set; }
        public DbSet<ToppingNCategory> ToppingNCategorys { get; set; }
        
    }
}
