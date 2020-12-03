using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using System.Net.WebSockets;
using System.Text;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;

namespace webserver.Middelware
{
    public class WebSocketMiddelware
    {

        private readonly RequestDelegate _next; // Next object in the middelware pipeline
        private readonly WebSocketConnectionManager _manager; // Class manages the connections
        private readonly ILogger<WebSocketMiddelware> _logger;

        public WebSocketMiddelware(RequestDelegate next, WebSocketConnectionManager manager, ILogger<WebSocketMiddelware> logger)
        {
            _next = next;
            _manager = manager;
            _logger = logger;
        }


        public async Task InvokeAsync(HttpContext context)
        {
            WriteRequestParam(context);
            if (context.WebSockets.IsWebSocketRequest) // Check if request is websocket request
            {
                using (WebSocket webSocket = await context.WebSockets.AcceptWebSocketAsync())
                {
                    _logger.LogInformation("WebSocket Connected");
                    
                    string ConnectionID = _manager.AddSocket(webSocket); // Add connection to websocket management class
                    await Echo(webSocket, ConnectionID); // return the first message with their connection ID
                    await RecieveMessage(webSocket, async (result, buffer) => // Handle the incomming websocket message
                    {
                        if(result.MessageType == WebSocketMessageType.Text) // Runs when the message recieved is of text type
                        {
                            _logger.LogDebug("Recieved a websocket message of type text");
                            _logger.LogDebug($"Message: {Encoding.UTF8.GetString(buffer, 0, result.Count)}"); // Print message to console for debugging
                            return;
                        }
                        else if(result.MessageType == WebSocketMessageType.Close) // Remove websocket from dictionary and close the connection
                        {
                            WebSocket sock = _manager.RemoveSocket(webSocket);
                            await sock.CloseAsync(result.CloseStatus.Value, result.CloseStatusDescription, CancellationToken.None);
                            return;
                        }
                    });
                }
            }
            else
            {
                await _next(context); // Send message to the next item in the pipline and await new request
            }
            
        }

        // Responds to the inital connection
        // TODO: Make it also return the first message sent
        private async Task Echo(WebSocket webSocket, string connectionID)
        {
            var buffer = Encoding.UTF8.GetBytes("ConnID: " + connectionID);
            await webSocket.SendAsync(buffer, WebSocketMessageType.Text, true, CancellationToken.None);
        }

        // Reads the incomming websocket message
        // TODO: Handle sudden disconnection
        // TODO: Handle JWT from game server
       private async Task RecieveMessage(WebSocket socket, Action<WebSocketReceiveResult, byte[]> handleMessage)
        {
            var buffer = new byte[1024 * 4];
            while(socket.State == WebSocketState.Open) // As long as connection is open, listen for new messages
            {
                var result = await socket.ReceiveAsync(buffer: new ArraySegment<byte>(buffer), cancellationToken: CancellationToken.None);
                handleMessage(result, buffer);
            }
        }


        // TODO: Handle larger than 1024*4 message sizes by slizing them into multiple messages
        public async Task<string> SendMessage(List<Claim> claims, WebSocket socket)
        {
            string token = Token(claims);
            var buffer = Encoding.UTF8.GetBytes(token);
            await socket.SendAsync(buffer, WebSocketMessageType.Text, true, CancellationToken.None);
            return token;
        }

        // Prints out the request parameters from the HTTP request
        public void WriteRequestParam(HttpContext context)
        {
            Console.WriteLine("Request Method: " + context.Request.Method);
            Console.WriteLine("Request Protocol: " + context.Request.Protocol);

            if (context.Request.Headers != null)
            {
                foreach (var h in context.Request.Headers)
                {
                    Console.WriteLine("--> " + h.Key + " : " + h.Value);
                }
            }
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
