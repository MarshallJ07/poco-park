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
	cam.position = cam.position.lerp(targetCam, 5 * delta)
	
	print(cam.position + get_viewport_rect().size / cam.zoom)
	_create_wall(StaticBody2D.new(), Vector2.LEFT, cam.position + (get_viewport_rect().size / cam.zoom / 2) )
	_create_wall(StaticBody2D.new(), Vector2.RIGHT, cam.position - (get_viewport_rect().size / cam.zoom / 2) )
	_create_wall(StaticBody2D.new(), Vector2.UP, cam.position + (get_viewport_rect().size / cam.zoom / 2) )
	_create_wall(StaticBody2D.new(), Vector2.DOWN, cam.position - (get_viewport_rect().size / cam.zoom / 2) )


func _create_wall(body: Node, normal: Vector2, pos: Vector2):
	var collision = CollisionShape2D.new()
	var shape = WorldBoundaryShape2D.new()
	
	# The normal points in the direction the wall pushes back
	shape.normal = normal
	collision.shape = shape
	collision.position = pos
	
	body.add_child(collision)
	
	
	
	
	
	
