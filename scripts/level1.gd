extends Node2D


var roles = [
	"gravity",
	"bouncy",
	"size",
	"platform"
]
var ability: String
var activePlatform = 1
@onready var game: Node2D = get_parent()
@onready var cam: Camera2D = get_parent().get_node("cam")
@onready var players: Node2D = get_parent().get_node("players")

func _ready() -> void:
	roles.shuffle()
	for index in game.ids.size():
		assign_ability.rpc_id(game.ids[index],roles[index])
	
	if activePlatform == 1:
		for i in $"spawnable platforms1".get_children():
			i.get_child(0).disabled = true
			i.get_child(1).modulate = Color("333333ff")
@rpc("any_peer","call_local","reliable")
func assign_ability(assignedAbility:String) -> void:
	
	ability = assignedAbility
	ability = "platform"
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ability"):
		if ability == "gravity":
			switch_grav.rpc()
			
		if ability == "size":
			change_size.rpc()
			
		if ability == "platform":
			change_platforms.rpc()
			
	if !multiplayer.is_server():
		return
	var targetCam := Vector2.ZERO
	for player in game.players:
		targetCam += player.position
	targetCam /= game.players.size()
	cam.position = cam.position.lerp(targetCam, 5 * delta)
	$screenWalls.position = cam.position
	
	
			
@rpc("any_peer","call_local","reliable")
func switch_grav() -> void:
	for player in players.get_children():
		player.gravDir *= -1
	
@rpc("any_peer","call_local","reliable")
func change_size() -> void:
	for player in players.get_children():
		if player.scale == Vector2(1.0,1.0):
			player.scale = Vector2(2.0,2.0)
		elif player.scale == Vector2(2.0,2.0):
			player.scale = Vector2(0.5,0.5)
		elif player.scale == Vector2(0.5,0.5):
			player.scale = Vector2(1.0,1.0)
	
@rpc("any_peer","call_local","reliable")
func change_platforms() -> void:
	activePlatform *= -1
	if activePlatform == 1:
		for i in $"spawnable platforms1".get_children():
			i.get_child(0).disabled = true
			i.get_child(1).modulate = Color("333333ff")
			
		for i in $"spawnable platforms2".get_children():
			i.get_child(0).disabled = false
			i.get_child(1).modulate = Color("ffffffff")
		
	else:
		for i in $"spawnable platforms2".get_children():
			i.get_child(0).disabled = true
			i.get_child(1).modulate = Color("333333ff")
		for i in $"spawnable platforms1".get_children():
			i.get_child(0).disabled = false
			i.get_child(1).modulate = Color("ffffffff")
