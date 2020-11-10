using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using webserver.Data;
using webserver.Models;
using webserver.Utility;

namespace webserver.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly ApplicationDbContext _context;

        public HomeController(ILogger<HomeController> logger, ApplicationDbContext context)
        {
            _logger = logger;
            _context = context;
        }
        // Main page, shows newest developer blogs
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> Index(int ? pageNumber)
        {
            var devBlogs = _context.DevBlogs.Include(d => d.ApplicationUser).OrderByDescending(s => s.Time);
            int pageSize = 5;
            return View(await PaginatedList<DevBlog>.CreateAsync(devBlogs.AsNoTracking(), pageNumber ?? 1, pageSize));
        }

        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> Privacy()
        {
            return await Task.Run(() => View());
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public async Task<IActionResult> Error()
        {
            return await Task.Run(() => View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier }));
        }
    }
}
