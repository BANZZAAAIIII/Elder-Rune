using Godot;
using System;
using Npgsql;

public class DatabaseConnection : Godot.Node
{
	public override void _Ready()
	{
		// Connects to database
		NpgsqlConnection conn = new NpgsqlConnection("Host=localhost;Username=postgres;Password=elruadmin;Database=postgres");
		
		try
		{	
			// Opens a connection for query
			conn.Open();
			int player_id = 1;  // get logged in player
		
			NpgsqlCommand player = new NpgsqlCommand("SELECT * FROM player WHERE player_id = " + player_id, conn);
			NpgsqlDataReader player_rdr = player.ExecuteReader();
			
			// Assign empty startvalues, will be overwritten by values from database
			double X_POSITION = 0.0;
			double Y_POSITION = 0.0;
			
			while (player_rdr.Read())
			{
				// get players position from databse
				X_POSITION = player_rdr.GetDouble(5);
				Y_POSITION = player_rdr.GetDouble(6);
			}
			// x,y position printed from database
			GD.Print("start x: ", X_POSITION, ", start y: ", Y_POSITION);
			// Close the connection
			conn.Close();
			
			
			conn.Open();
			Random random_x = new Random();
			Random random_y = new Random();
			
			// Randomizes x,y values for easier testing
			double NEW_X_POSITION = 200 * random_x.NextDouble();	// get players x position at disconnect
			double NEW_Y_POSITION = 200 * random_y.NextDouble();	// get players y position at disconnect
			
			// Call this when the user disconnects to save his x,y position
			var update = new NpgsqlCommand("UPDATE player SET x_position =  @NEW_X_POSITION, y_position = @NEW_Y_POSITION WHERE player_id = " + player_id, conn);
			update.Parameters.AddWithValue("@NEW_X_POSITION", NEW_X_POSITION);
			update.Parameters.AddWithValue("@NEW_Y_POSITION", NEW_Y_POSITION);
			update.ExecuteNonQuery();
			conn.Close();
			
			
			conn.Open();
			// Used this to check if the position was updated
			NpgsqlCommand updated_player = new NpgsqlCommand("SELECT * FROM player WHERE player_id = " + player_id, conn);
			NpgsqlDataReader updated_player_rdr = updated_player.ExecuteReader();
			
			while (updated_player_rdr.Read())
			{
				X_POSITION = updated_player_rdr.GetDouble(5);
				Y_POSITION = updated_player_rdr.GetDouble(6);
			}
			
			GD.Print("end x: " + X_POSITION + ", end y: " + Y_POSITION);
			conn.Close();
			
		}
		
		catch (Exception exception)
		{
			GD.Print(exception);
		}
		
	}

}
