using Godot;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

public class JwtDigest : Node
{
    string key;
    string issuer;
    string audience;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        key = "This key must be secured";
        issuer = "https:localhost:5001";
        audience = "Godot Game server";
    }

    public string _consumeToken(string token)
    {        
        try
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
            var validations = new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = securityKey,
                ValidateIssuer = false,
                ValidateAudience = false
            };

            var handler = new JwtSecurityTokenHandler();
            var jsonToken = handler.ValidateToken(token, validations, out var tokenSecure);
            Console.WriteLine(tokenSecure.ToString().Split('.')[1]);
            return tokenSecure.ToString().Split('.')[1];
        }
        catch(Exception e)
        {
            GD.Print("Not a Jwt: " + e.Message);
        }
        return token;
    }
}
