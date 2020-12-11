extends Node2D

remote func ping():
	rpc_unreliable_id(get_tree().get_rpc_sender_id(), "ping_answer")
