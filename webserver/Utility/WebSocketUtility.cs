using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net.WebSockets;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace webserver.Utility
{
    // TODO: Review this class, wether or not it should be moved to WebSocketMiddelware or not
    public class WebSocketUtility
    {
        // TODO: Handle larger than 1024*4 message sizes by slizing them into multiple messages
        public async Task<string> SendMessage(List<Claim> claims, WebSocket socket)
        {
            string token = Token(claims);
            var buffer = Encoding.UTF8.GetBytes(token);
            await socket.SendAsync(buffer, WebSocketMessageType.Text, true, CancellationToken.None);
            return token;
        }
        private string Token(List<Claim> claims)
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
