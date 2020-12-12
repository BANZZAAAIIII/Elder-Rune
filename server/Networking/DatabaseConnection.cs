using Godot;
using System;
using Npgsql;


public class DatabaseConnection : Node
{
	
	private NpgsqlConnection conn;
	public override void _Ready()
	{
		conn = new NpgsqlConnection("Host=localhost;Username=postgres;Password=elruadmin;Database=elru");
	}
	
	// Gets x,y position from user id, parameters (id)
	public Vector2 getPlayerPosition(string name)
	{
		try
		{
			conn.Open();
		
			string player_name = name;
			int X_POSITION = 0;
			int Y_POSITION = 0;
		
			NpgsqlCommand player = new NpgsqlCommand("SELECT * FROM players WHERE player_name = '"+ player_name + "'", conn);
			NpgsqlDataReader player_rdr = player.ExecuteReader();
			
			while (player_rdr.Read())
			{
				X_POSITION = player_rdr.GetInt32(1);
				Y_POSITION = player_rdr.GetInt32(2);
			}
			
			
			Vector2 player_position = new Vector2(X_POSITION, Y_POSITION);
			GD.Print("Current position: " + player_position);
			conn.Close();
			
			return player_position;
		
		}
			
		
		catch (Exception exception)
		{
			Vector2 player_pos = new Vector2(0, 0);
			return player_pos;
		}
	}
	// Updates player, parameters (id, x_pos, y_pos)
	public void updatePlayerPosition(string name, int x_pos, int y_pos)
	{
		try
		{
			conn.Open();
			
			string player_name = name;
			int X_POSITION = x_pos;
			int Y_POSITION = y_pos;
			
			var update = new NpgsqlCommand("UPDATE players SET x_position = @X_POSITION, y_position = @Y_POSITION WHERE player_name = '" + player_name + "'", conn);
			update.Parameters.AddWithValue("@X_POSITION", X_POSITION);
			update.Parameters.AddWithValue("@Y_POSITION", Y_POSITION);
			update.ExecuteNonQuery();
			conn.Close();
		}
		
		catch (Exception exception)
		{
			GD.Print(exception);
		}
	}
}
