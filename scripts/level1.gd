extends Node2D


var roles = [
	"gravity",
	"bouncy",
	"size",
	"platform"
]
var ability: String

@onready var game: Node2D = get_parent()
@onready var cam: Camera2D = get_parent().get_node("cam")

func _ready() -> void:
	roles.shuffle()
	print(game.ids)
	for index in game.ids.size():
		print(index)
		assign_ability.rpc_id(game.ids[index],roles[index])

@rpc("any_peer","call_local","reliable")
func assign_ability(assignedAbility:String) -> void:
	ability = assignedAbility
	print(ability)
	
func _physics_process(delta: float) -> void:
	var targetCam := Vector2.ZERO
	for player in game.players:
		targetCam += player.position
	targetCam /= game.players.size()
	print(cam)
	cam.position = cam.position.lerp(targetCam, 5 * delta)
	
	
	
	
	
	
	
	
	
