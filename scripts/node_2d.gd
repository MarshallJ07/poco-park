extends Node2D



const PROTO_CONTROLLER = preload("uid://bs72ogkvdd7d6")

var players: Array[CharacterBody2D]
var spawnOrder: int
var currentSpawn: int = 0
var amountOfPlayers := 1




var ids = []

func _ready():
	Networking.host_created.connect(_on_host_created)
	multiplayer.peer_connected.connect(_peer_connected)
	
	
	
	
func _on_host_created():
	spawnOrder = currentSpawn
	currentSpawn += 1
	ids.append(1)
	send_amount_of_players.rpc(amountOfPlayers)
func _peer_connected(peer_id:int):
	ids.append(peer_id)
	if multiplayer.is_server():
		get_spawn_order(currentSpawn)
		currentSpawn += 1
		amountOfPlayers += 1
		send_amount_of_players.rpc(amountOfPlayers)
		waiting.rpc_id(peer_id)

@rpc("any_peer","call_local","reliable")
func waiting(num:int) -> void:
	$CanvasLayer/start.hide()
	$CanvasLayer/host.hide()
	$CanvasLayer/waiting.show()
	
@rpc("any_peer","reliable")
func get_spawn_order(num) -> void:
	spawnOrder = num
	
@rpc("any_peer","call_local","reliable")
func send_amount_of_players(num:int) -> void:
	$CanvasLayer/amountOfPlayers.text = "Players: " + str(num) + "/4"
	
func _on_button_pressed() -> void:
	$CanvasLayer/host.disabled = true
	Networking.host_lobby()
	

func _on_start_pressed() -> void:
	if !multiplayer.is_server():
		return
	hide_buttons.rpc()

func restart() -> void:
	free_everything.rpc()
	
	
@rpc("any_peer","call_local","reliable")
func free_everything() -> void:
	get_node("level").queue_free()
	get_node("level").name = "freed"
	players = []
	for i in $players.get_children():
		i.queue_free()
	hide_buttons()
@rpc("any_peer","call_local","reliable")
func hide_buttons() -> void:
	$CanvasLayer/host.hide()
	$CanvasLayer/start.hide()
	$CanvasLayer/amountOfPlayers.hide()
	var level = preload("res://scenes/level.tscn").instantiate()
	level.name = "level"
	add_child(level)
	
func initialize_player(player:CharacterBody2D):
	player.global_position = $spawnpoint.global_position
	players.append(player)
	
@rpc("authority","call_local","reliable")
func spawn_player(peer_id:int):
	$CanvasLayer/waiting.hide()
	var player := PROTO_CONTROLLER.instantiate()
	player.name = str(peer_id)
	player.set_multiplayer_authority(peer_id)
	$players.add_child(player)
	initialize_player(player)
	
	
