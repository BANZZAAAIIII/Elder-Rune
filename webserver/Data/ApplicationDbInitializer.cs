using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using webserver.Models;

namespace webserver.Data
{
    public class ApplicationDbInitializer
    {
        public static void Initialize(ApplicationDbContext db, UserManager<ApplicationUser> um, RoleManager<IdentityRole> rm)
        {
            // Delete and create database while testing
            db.Database.EnsureDeleted();
            db.Database.EnsureCreated();

            //------------------------------User test data--------------------------------------
            var adminRole = new IdentityRole("Admin"); // Create role object
            rm.CreateAsync(adminRole).Wait();     // Add role to RoleManager

            // Create an administrator
            var admin = new ApplicationUser 
            {
                UserName = "admin",
                Email = "admin@uia.no",                
                EmailConfirmed = true
            };

            um.CreateAsync(admin, "Password1.").Wait(); // Async lets your program to continue the code even though the funciton is not finished

            um.AddToRoleAsync(admin, "Admin").Wait(); // Add Admin role to admin user


            // Create users
            for (int i = 1; i <= 5; i++)
            {
                var user = new ApplicationUser
                {
                    UserName = $"user{i}",
                    Email = $"user{i}@uia.no",                    
                    EmailConfirmed = true
                };

                um.CreateAsync(user, "Password1.").Wait();
            }

            db.SaveChanges();

            //--------------------------------DevBlog test data----------------------------------------------------
            foreach(var user in db.ApplicationUsers.Include(u => u.DevBlogs))
            {
                for (int i = 1; i <= 20; i++)
                {
                    var day = 1;
                    int month = 1;
                    int year = 1980;
                    Random r = new Random();
                    string str = "ipuashdnuoyaisdngoasuydgbasouydgabpiufhiua afiubpasnfgbsauyof ayvfbnsapifgasuiybgf uiasgnfip";
                    user.DevBlogs.Add(new DevBlog
                    {
                        Title = $"DevBlog {i}",
                        Summary = $"DevBlog Summary {i}",
                        Content = new string(str.ToCharArray().OrderBy(s => (r.Next(2) % 2) == 0).ToArray()),
                        Time = new DateTime(year, month, day)
                    });
                    day += 1;
                    month += 1;
                    year += 1;

                    if (month >= 12) month = 1;
            }
            }

            db.SaveChanges();
        }
    }
}
