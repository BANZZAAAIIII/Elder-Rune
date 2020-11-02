extends TileMap

# This script moves the tilset along the x axis 512 pixels each interval
# Causing a simple animation

var timer = null
var delay = 1.0

var region_x = 0

var size = 256 * 8 # Size of one set * number of animation frames


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new() # Create a timer
	add_child(timer)
	
	timer.connect("timeout", self, "_on_Timer_timeout") # Create connection
	timer.set_wait_time(delay)	# Set timer delay
	timer.set_one_shot(false) # Make timer loop
	timer.start()		# Start timer

func _on_Timer_timeout():
	delay = rand_range(0.5, 1.2) # Create random intervals for timer
	timer.set_wait_time(delay)	# Set new delay on timer
	region_x += 256			# Move over one frame
	region_x %= size	# Goes to 0 when region_x is equal to size
	tile_set.tile_set_region(0, Rect2(region_x, 0.0, 256.0, 192)) # Rectangle(start_x, start_y, width, height)
	tile_set.tile_set_region(1, Rect2(region_x, 0.0, 256.0, 192)) # Rectangle(start_x, start_y, width, height)
	tile_set.tile_set_region(2, Rect2(region_x, 0.0, 256.0, 192)) # Rectangle(start_x, start_y, width, height)
	tile_set.tile_set_region(3, Rect2(region_x, 0.0, 256.0, 192)) # Rectangle(start_x, start_y, width, height)
	tile_set.tile_set_region(4, Rect2(region_x, 0.0, 256.0, 192)) # Rectangle(start_x, start_y, width, height)
