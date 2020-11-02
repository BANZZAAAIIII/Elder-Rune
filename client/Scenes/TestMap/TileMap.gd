extends TileMap

# This script moves the tilset along the x axis 512 pixels each interval
# Causing a simple animation

var timer = null
var delay = 1.0

var region_x = 0

var size = 256 * 4 # Size of one set * number of animation frames

var tile_sets = null


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new() # Create a timer
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout") # Create connection
	timer.set_wait_time(delay)	# Set timer delay
	timer.set_one_shot(false) # Make timer loop
	timer.start()		# Start timer
	
	tile_sets = tile_set.get_tiles_ids() # Get id of all the tilesets

func _on_Timer_timeout():
	delay = rand_range(0.5, 1.2) # Create random intervals for timer
	timer.set_wait_time(delay)	# Set new delay on timer
	region_x += 256			# Move over one frame
	region_x %= size	# Goes to 0 when region_x is equal to size
	
	for set in tile_sets:
		tile_set.tile_set_region(set, Rect2(region_x, 0.0, 256.0, 192)) # Move the tile region
	
	
