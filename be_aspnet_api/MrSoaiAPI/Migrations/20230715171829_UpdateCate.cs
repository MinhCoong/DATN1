using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MrSoaiAPI.Migrations
{
    public partial class UpdateCate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "CategoryId",
                table: "Toppings",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Toppings_CategoryId",
                table: "Toppings",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Toppings_Categorys_CategoryId",
                table: "Toppings",
                column: "CategoryId",
                principalTable: "Categorys",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Toppings_Categorys_CategoryId",
                table: "Toppings");

            migrationBuilder.DropIndex(
                name: "IX_Toppings_CategoryId",
                table: "Toppings");

            migrationBuilder.DropColumn(
                name: "CategoryId",
                table: "Toppings");
        }
    }
}
