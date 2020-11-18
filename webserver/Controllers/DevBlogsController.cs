using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using webserver.Data;
using webserver.Models;
using webserver.Utility;

namespace webserver
{
    public class DevBlogsController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<DevBlogsController> _logger;
        private readonly UserManager<ApplicationUser> _userManager;

        public DevBlogsController(ILogger<DevBlogsController> logger, ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _logger = logger;
            _context = context;
            _userManager = userManager;
        }

        // GET: DevBlogs
        // Main DevBlog page, list all dev blogs
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.DevBlogs.Include(d => d.ApplicationUser).OrderByDescending(s => s.Time);
            return View(await applicationDbContext.ToListAsync());
        }


        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> GetDevBlog(int ? pageNumber)
        {
            var applicationDbContext = _context.DevBlogs.Include(d => d.ApplicationUser).OrderByDescending(s => s.Time);
            int pageSize = 5;       // Number of items to return from database
            return PartialView("_DevBlogSummaryPartial", await PaginatedList<DevBlog>.CreateAsync(applicationDbContext.AsNoTracking(), pageNumber ?? 1, pageSize));
        }

        // GET: DevBlogs/Details/5
        // Show single devblog post
        [HttpGet]
        [AllowAnonymous]
        public async Task<IActionResult> Details(int ? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var devBlog = await _context.DevBlogs
                .Include(d => d.ApplicationUser)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (devBlog == null)
            {
                return NotFound();
            }

            return View(devBlog);
        }

        // GET: DevBlogs/Create
        [HttpGet]
        [Authorize(Roles = "Admin")]
        public IActionResult Create()
        {
            ViewData["ApplicationUserId"] = new SelectList(_context.ApplicationUsers, "Id", "Id");
            return View();
        }

        // POST: DevBlogs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [Authorize(Roles = "Admin")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Title,Summary,Content,Time,ApplicationUserId")] DevBlog devBlog)
        {
            if (ModelState.IsValid)
            {
                _context.Add(devBlog);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["ApplicationUserId"] = new SelectList(_context.ApplicationUsers, "Id", "Id", devBlog.ApplicationUserId);
            return View(devBlog);
        }

        // GET: DevBlogs/Edit/5
        [HttpGet]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var devBlog = await _context.DevBlogs.FindAsync(id);
            if (devBlog == null)
            {
                return NotFound();
            }
            ViewData["ApplicationUserId"] = new SelectList(_context.ApplicationUsers, "Id", "Id", devBlog.ApplicationUserId);
            return View(devBlog);
        }

        // POST: DevBlogs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [Authorize(Roles = "Admin")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Title,Summary,Content,Time,ApplicationUserId")] DevBlog devBlog)
        {
            if (id != devBlog.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(devBlog);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DevBlogExists(devBlog.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["ApplicationUserId"] = new SelectList(_context.ApplicationUsers, "Id", "Id", devBlog.ApplicationUserId);
            return View(devBlog);
        }

        // GET: DevBlogs/Delete/5
        [HttpGet]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var devBlog = await _context.DevBlogs
                .Include(d => d.ApplicationUser)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (devBlog == null)
            {
                return NotFound();
            }

            return View(devBlog);
        }

        // POST: DevBlogs/Delete/5
        [HttpPost, ActionName("Delete")]
        [Authorize(Roles = "Admin")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var devBlog = await _context.DevBlogs.FindAsync(id);
            _context.DevBlogs.Remove(devBlog);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool DevBlogExists(int id)
        {
            return _context.DevBlogs.Any(e => e.Id == id);
        }
    }
}
