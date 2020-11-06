using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using webserver.Data;
using webserver.Models;

namespace webserver
{
    public class DevBlogsController : Controller
    {
        private readonly ApplicationDbContext _context;

        public DevBlogsController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: DevBlogs
        public async Task<IActionResult> Index()
        {
            var applicationDbContext = _context.DevBlogs.Include(d => d.ApplicationUser);
            return View(await applicationDbContext.ToListAsync());
        }

        // GET: DevBlogs/Details/5
        public async Task<IActionResult> Details(int? id)
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
        public IActionResult Create()
        {
            ViewData["ApplicationUserId"] = new SelectList(_context.ApplicationUsers, "Id", "Id");
            return View();
        }

        // POST: DevBlogs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Title,summary,Content,Time,ApplicationUserId")] DevBlog devBlog)
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
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Title,summary,Content,Time,ApplicationUserId")] DevBlog devBlog)
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
