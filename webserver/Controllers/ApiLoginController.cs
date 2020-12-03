using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using webserver.Models;
using webserver.Middelware;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using webserver.Utility;


namespace webserver.Controllers
{
    [Route("api/")]
    [ApiController]
    public class ApiLoginController : ControllerBase
    {

        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly ILogger<ApiLoginController> _logger;
        private readonly WebSocketConnectionManager _webSocket;


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
        public async Task<IActionResult> Login([FromBody] LoginModel model)
        {

            _logger.LogInformation(model.ToString());
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var user = await this._userManager.FindByNameAsync(model.UserName);
            if (user == null)
            {
                return Unauthorized();
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, model.Password, lockoutOnFailure: false);
            if (result.Succeeded)
            {                
                _logger.LogInformation($"User {user} logged into {model.World}");

                List<Claim> claims = new List<Claim>();
                claims.Add(new Claim("Login", "true"));
                claims.Add(new Claim("user", user.UserName));
                claims.Add(new Claim("guid", Guid.NewGuid().ToString()));                
                var sender = new WebSocketUtility();                
                string token = await sender.SendMessage(claims, _webSocket.FindSocket());
                return Ok(token);
            }
            else
            {
                ModelState.AddModelError(string.Empty, "Invalid login attempt.");
                return BadRequest(ModelState);
            }
        }

       private string LoginToken(List<Claim> claims)
        {
            
            string key = "This key must be secured";

            var issuer = "https:localhost:5001";
            var audience = "Godot Game server";
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);                  

            // Create token object
            var token = new JwtSecurityToken(
                issuer,
                audience,
                claims,
                expires: DateTime.Now.AddSeconds(30),
                signingCredentials: credentials
                );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
