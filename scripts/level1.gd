extends Node2D


var roles = [
	"gravity",
	"bouncy",
	"size",
	"platform"
]
var ability: String

@onready var game = get_parent()

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
