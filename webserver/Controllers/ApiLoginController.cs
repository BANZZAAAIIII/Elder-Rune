using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using webserver.Models;
using Microsoft.IdentityModel.JsonWebTokens;

namespace webserver.Controllers
{
    [Route("api/")]
    [ApiController]
    public class ApiLoginController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly ILogger<ApiLoginController> _logger;


        // Constructor
        public ApiLoginController(ILogger<ApiLoginController> logger, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _logger = logger;
        }

        // Test connection
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var user = await this._userManager.FindByNameAsync("user1");
            return Ok(user);
        }


        // Recieves a login model
        // POst api/Login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody]LoginModel model) 
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var user = await this._userManager.FindByNameAsync(model.UserName); 
            if(user == null)
            {
                return Unauthorized();
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, model.Password, lockoutOnFailure: false);
            if (result.Succeeded)
            {
                _logger.LogInformation("User logged in");
              
                return Ok("You Logged in");
            }
           else
            {
                ModelState.AddModelError(string.Empty, "Invalid login attempt.");
                return BadRequest(ModelState);
            }

        }
    }
}
