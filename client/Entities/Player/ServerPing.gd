extends Node2D


var ping
var time
var client_time
var server_time

onready var timer_node = get_node("PingTimer")


func _ready():
	timer_node.set_wait_time(0.5)
	timer_node.start()
	
	$ServerPingDisplay.text = (
		"ping		: " 
		+"\nPing to 	: "
		+"\nPing from 	: "
		+"\nAvg ping 	: "
	)



func _on_PingTimer_timeout():
	time = OS.get_ticks_msec()	
	rpc_id(Server.SERVER_ID, "ping")


remote func ping_answer(s_time):
	ping = OS.get_ticks_msec() - time
	client_time = s_time - time
	server_time = s_time - OS.get_ticks_msec()
	print(ping)
	
	
	$ServerPingDisplay.text = (
		"ping		: " + str(ping )
		+"\nPing to 	: " + str(client_time )
		+"\nPing from 	: " + str(server_time )
		+"\nAvg ping 	: " # TODO
	)
