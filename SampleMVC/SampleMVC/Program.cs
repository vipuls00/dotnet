using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Drawing.Text;

namespace SampleMVC
{
    public class Program
    {
        private static IConfiguration _configuration;
        public Program(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        public static void Main(string[] args)
        {

            var builder = WebApplication.CreateBuilder(args);
            var coonectionString = builder.Configuration.GetConnectionString("AssetDb");
            builder.Services.AddDbContext<AppDbContext>(options =>
            {
                options.UseMySql(coonectionString, ServerVersion.AutoDetect(coonectionString));
            });
            builder.Services.AddControllersWithViews();

                var app = builder.Build();

                // Configure the HTTP request pipeline.
                if (!app.Environment.IsDevelopment())
                {
                    app.UseExceptionHandler("/Home/Error");
                    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                    app.UseHsts();
                }


                app.UseHttpsRedirection();
                app.UseStaticFiles();

                app.UseRouting();

                app.UseAuthorization();

                app.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");

                app.Run();
            }
    }
}