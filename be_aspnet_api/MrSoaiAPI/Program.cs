using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using MrSoaiAPI.Data;
using MrSoaiAPI.Handler;
using MrSoaiAPI.Hubs;
using MrSoaiAPI.Interface;
using MrSoaiAPI.Model;
using MrSoaiAPI.Units;
using System.Text;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    options.JsonSerializerOptions.MaxDepth = 64;
    options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull; // Bỏ qua giá trị null khi chuyển đổi thành JSON
    options.JsonSerializerOptions.WriteIndented = true; // Ghi JSON với định dạng thụt đầu dòng
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddTransient<IImageHandler, ImageHandler>();
builder.Services.AddTransient<IImageWriter, ImageWriter>();
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession((optional) =>
{
    optional.Cookie.Name = "Mrsoai";
    optional.IdleTimeout = TimeSpan.FromDays(1);
    optional.Cookie.IsEssential = true;

});
builder.Services.AddSignalR();
builder.Services.AddCors(options =>
    options.AddDefaultPolicy(policy => 
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));
//Đăng ký Identity
builder.Services.AddIdentity<MrSoaiUser,IdentityRole>()
    .AddEntityFrameworkStores<MrSoaiAPIContext>().AddDefaultTokenProviders();

builder.Services.AddDbContext<MrSoaiAPIContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("MrSoaiAPIConnectString"));
});

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.SaveToken = true;
    options.RequireHttpsMetadata = false;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidAudience = builder.Configuration["JWT:ValidAudience"],
        ValidIssuer= builder.Configuration["JWT:ValidIssuer"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["JWT:Secret"])),
    };
});

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyHeader().AllowAnyMethod().AllowCredentials().SetIsOriginAllowed((host) => true);
    });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseCors();

app.UseHttpsRedirection();

app.UseAuthentication();

app.MapHub<WebSocketHub>("/Websocket");
app.UseSession();

app.UseStaticFiles();
app.UseRouting();
app.UseAuthorization();

app.MapControllers();
app.MapAreaControllerRoute(
    name: "MyareaAdmin",
    areaName: "Admin",
     pattern: "Admin/{controller=Home}/{action=Index}/{id?}");

app.UseEndpoints(endpoints =>
{
    endpoints.MapAreaControllerRoute(
        name: "MyareaAdmin",
        areaName: "Admin",
        pattern: "Admin/{controller=Home}/{action=Index}/{id?}"
    );
});

app.Run();
