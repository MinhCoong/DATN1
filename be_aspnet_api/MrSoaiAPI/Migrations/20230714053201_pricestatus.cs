using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MrSoaiAPI.Migrations
{
    public partial class pricestatus : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "Status",
                table: "Prices",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Status",
                table: "Prices");
        }
    }
}
