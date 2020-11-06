﻿using Microsoft.AspNetCore.Identity;
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

            var adminRole = new IdentityRole("Admin"); // Create role object
            rm.CreateAsync(adminRole).Wait();     // Add role to RoleManager

            // Create an administrator
            var admin = new ApplicationUser 
            {
                UserName = "admin@uia.no",
                Email = "admin@uia.no",
                GamerTag = "Administrator",
                EmailConfirmed = true
            };

            um.CreateAsync(admin, "Password1.").Wait(); // Async lets your program to continue the code even though the funciton is not finished

            um.AddToRoleAsync(admin, "Admin"); // Add Admin role to admin user


            // Create users
            for (int i = 1; i <= 5; i++)
            {
                var user = new ApplicationUser
                {
                    UserName = $"user{i}@uia.no",
                    Email = $"user{i}@uia.no",
                    GamerTag = $"User{i}",
                    EmailConfirmed = true
                };

                um.CreateAsync(user, "Password1.").Wait();
            }

            db.SaveChanges();
        }
    }
}
