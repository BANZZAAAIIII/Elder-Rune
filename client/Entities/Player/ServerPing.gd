extends Node2D


var ping
var time
var avg_ping


onready var timer_node = get_node("PingTimer")

signal PingAnswer

func _ready():
	# initiates the timer
	timer_node.set_wait_time(0.5)
	timer_node.start()
	
	ping = []
	
	# initiate the display
	$ServerPingDisplay.text = (
		"ping : " 
		+"\nAvg ping : "
	)


func _on_PingTimer_timeout():
	time = OS.get_ticks_msec()	
	rpc_unreliable_id(Server.SERVER_ID, "ping")
	
	if ping.size() > 10:
		ping.pop_back()


remote func ping_answer(s_time):
	ping.push_front(OS.get_ticks_msec() - time) 
	
	emit_signal("PingAnswer", ping.front())
	var sum = 0
	for p in ping:
		sum += p
	avg_ping = sum / ping.size()
	
	$ServerPingDisplay.text = (
		"ping : " + str(ping.front()) + " msec"
		+"\nAvg ping : " + str(avg_ping) + " msec"
	)
