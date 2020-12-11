extends Node2D


var ping
var time
var avg_ping
var avg_ping_time

onready var timer_node = get_node("PingTimer")

signal PingAnswer

func _ready():
	# initiates the timer
	timer_node.set_wait_time(0.5)
	timer_node.start()
	
	ping = []
	avg_ping_time = 10 # seconds
	
	# initiate the display
	$ServerPingDisplay.text = (
		"ping : " 
		+"\nAvg ping : "
	)

# Starts the ping to the server 
func _on_PingTimer_timeout():
	time = OS.get_ticks_msec()	
	rpc_unreliable_id(Server.SERVER_ID, "ping")
	
	if ping.size() > avg_ping_time * 2:
		ping.pop_back()


remote func ping_answer():
	ping.push_front(OS.get_ticks_msec() - time) 
	
	var sum = 0
	for p in ping:
		sum += p
	avg_ping = sum / ping.size()
	
	# Sends the average ping, sends ping if its 50 ms higher or lower
	if abs(avg_ping - ping.front()) > 20:
		emit_signal("PingAnswer", ping.front())
	else:
		emit_signal("PingAnswer", avg_ping)
		
	$ServerPingDisplay.text = (
		"ping : " + str(ping.front()) + " msec"
		+"\nAvg ping : " + str(avg_ping) + " msec"
	)
