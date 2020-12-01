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
using webserver.Middelware;
using System.Net.WebSockets;
using System.Text;
using System.Threading;

namespace webserver.Controllers
{
    [Route("api/")]
    [ApiController]
    public class ApiLoginController : ControllerBase
    {
        
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly ILogger<ApiLoginController> _logger;
        private WebSocketConnectionManager _webSocket;


        // Constructor
        public ApiLoginController(ILogger<ApiLoginController> logger, SignInManager<ApplicationUser> signInManager, UserManager<ApplicationUser> userManager, WebSocketConnectionManager webSocket)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _logger = logger;
            _webSocket = webSocket;
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

            _logger.LogInformation(model.ToString());
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
                _logger.LogInformation($"User {user} logged into {model.World}");
                WebSocket webSocket = _webSocket.FindSocket();
                var buffer = Encoding.UTF8.GetBytes("Login: " + user);
                await webSocket.SendAsync(buffer, WebSocketMessageType.Text, true, CancellationToken.None);
              
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
