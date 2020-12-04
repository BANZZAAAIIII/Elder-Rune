using Godot;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;


/* Login Token Body Format:
 * 
 * "user": [username],
 * "guid": [Guid],
 * "exp": [Datetime.now + 30 seconds],
 * "iss": [Issuer:https://localhost:5001],
 * "aud": [Audince:Godot Game Server]
 * 
 */



public class Token : Node
{
	Timer checkExpiredToken;
	string key;
	
	// TODO: Make this a Dictionary<string, Dictionary<string, string>>??????
	List<Dictionary<string, string>> serverTokens; // Holds list over token from webserver to be validated
	Dictionary<int, string> clientTokens; // Holds a dictionary over peer tokens to be validated

	[Signal]
	public delegate void ValidatePlayer(int ID, string username, bool validation);

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		checkExpiredToken = new Timer();
		checkExpiredToken.WaitTime = 30; // Set timer to check for expired tokens every 30 seconds
		checkExpiredToken.OneShot = false;
		this.AddChild(checkExpiredToken);
		checkExpiredToken.Connect("timeout", this, nameof(CheckExpiredTokens));


		key = "This key must be secured";
		// issuer = "https:localhost:5001";
		//audience = "Godot Game server";

		clientTokens = new Dictionary<int, string>();
		serverTokens = new List<Dictionary<string, string>>();

	}

	public void consumeToken(string token)
	{
		try{
			GD.Print("\nServer:");
			serverTokens.Add(validateToken(token)); // Add Server token to list
			if (checkExpiredToken.IsStopped()) // Restart timer if it has stopped
				checkExpiredToken.Start();	
			
		}
		catch(Exception e)
		{
			GD.Print("Invalid Jwt Token: " + e.Message);
		}
	}


	// TODO: Handle exceptions where Game server token arrives after client login request
	// TODO: Make this funciton asynchronus instead of yielding for a set time
	public async Task compareTokens(int peerID)
	{
		GD.Print("\nClient:");
		try
		{
            //GD.Print("\nClient:");
			if (clientTokens.TryGetValue(peerID, out string token))
			{
				GD.Print(clientTokens[peerID]);
				Dictionary<string, string> clientToken = validateToken(clientTokens[peerID]);
				Dictionary<string, string> serverToken = null;				
				clientToken.TryGetValue("guid", out string guid);
				clientToken.TryGetValue("user", out string username);
				clientToken.TryGetValue("exp", out string time);
				GD.Print("\nTime: " + time + "\nGuid: " + guid + "\nUsername: " + username + "\n");
				_ = long.TryParse(time, out long unix);
                while (unix - DateTimeOffset.Now.ToUnixTimeSeconds() < 60) // Loop for as long as less than 30 seconds have passed
				{					
					serverToken = findTokenUsername(username);
					if(serverToken != null)
                    {						
						_ = serverToken.TryGetValue("guid", out string sGuid);
						if (guid == sGuid)
                        {							
							EmitSignal(nameof(ValidatePlayer), peerID, username, true);               // Does not work, as Godot does not have await/async operators              // Token is the same on both client and game server
							clientTokens.Remove(peerID);	// Remove tokens
							serverTokens.Remove(serverToken);
							serverToken = null;
							return;
						}					
                    }
                    else
                    {
						await ToSignal(GetTree().CreateTimer(2), "timeout"); // Timer fires after 2 seconds resuming the while loop
                    }
                }
				
			}			
		}
		catch(Exception e)
		{
			GD.PrintErr(e);
		}
		EmitSignal("ValidatePlayer", peerID, false);
	}

	public void addClient(int peerID, string token)
	{		
		clientTokens.Add(key:peerID, value:token);
		_ = compareTokens(peerID);
	}

	// Get the body values from the Jwt
	private Dictionary<string, string> validateToken(string token)
	{
		Dictionary<string, string> temp = new Dictionary<string, string>();
		try
		{
			GD.Print("Validation:\n" + token);
			var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
			var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);
			var validations = new TokenValidationParameters // Validation parameters to check, defined in https://docs.microsoft.com/en-us/dotnet/api/microsoft.identitymodel.tokens.tokenvalidationparameters?view=azure-dotnet
			{
				ValidateIssuerSigningKey = true,
				IssuerSigningKey = securityKey,
				ValidateIssuer = false,
				ValidateAudience = false,
				ValidateLifetime = true,
				
			};

			var handler = new JwtSecurityTokenHandler();
			var jsonToken = handler.ValidateToken(token, validations, out var tokenSecure); // TODO: Test all checked validations for the token
			foreach (Claim claim in jsonToken.Claims)
			{
				temp.Add(claim.Type.ToString(), claim.Value.ToString());
			}
			printToken(temp);

			GD.Print("\n\tVALIDATION SUCCESSFULL\n\t");
		}
        //catch (Microsoft.IdentityModel.Tokens.SecurityTokenExpiredException e) // Compiler error CS0433 use general exception instead
        //{
        //    GD.Print(e.Message);
        //}
       
		catch (Exception e)
		{
			//throw new Exception("Could not validate token: " + e.Message);
			GD.PrintErr("Couldn't validate token: " + e.Message);
		}
		return temp;
	}

	private Dictionary<string, string> findTokenUsername(string username)
	{		
		foreach(Dictionary<string, string> item in serverTokens)
		{			
			if (item.TryGetValue("user", out string user) && user == username)
				return item;
		}
		throw new Exception("Didn't find the token");
	}
	private string findToken(int peerID)
	{
		foreach (KeyValuePair<int, string> item in clientTokens)
		{
			if (item.Key == peerID)
				return item.Value;
		}
		throw new Exception("Didn't find the token");
	}

	private void printToken(Dictionary<string, string> temp)
	{		
		try
		{
			foreach (KeyValuePair<string, string> s in temp)
			{
				GD.Print(s.Key + ":" + s.Value);
			}
		}
		catch(Exception e)
		{
			GD.PrintErr("PrintToken Error: " + e.Message);
		}
	}
	private void printTokenList()
	{
		try
		{
			foreach (var item in serverTokens)
			{
				printToken(item);
			}
		}
		catch(Exception e)
		{
			GD.PrintErr(e);
		}
	}

	private void CheckExpiredTokens()
	{
		try
		{
			for (int i = serverTokens.Count(); i > 0; i--) // Loop backwards through the list
			{
				GD.Print(i);
				serverTokens[i].TryGetValue("exp", out string time);				
				if (long.TryParse(time, out long unix) && unix > DateTimeOffset.Now.ToUnixTimeSeconds())
                {
					GD.Print("Removed: " + serverTokens[i]);
					serverTokens.RemoveAt(i);
				}
					
			}
		}
		catch(ArgumentNullException e)
		{
			GD.Print("No token in token list" + e.Message);
			checkExpiredToken.Stop(); // Stop checking for expired tokens
		}

		catch(Exception e)
		{
			GD.PrintErr("CheckExpiredTokensError: " + e.Message);
		}
	}
}

