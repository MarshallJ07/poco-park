extends CharacterBody2D

@export var friction = 800.0

# Get gravity from project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Apply gravity if falling
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Apply friction so the crate stops sliding when the player stops pushing
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	move_and_slide()

# The player will call this function when they walk into the crate
func push(push_velocity: Vector2):
	velocity.x = push_velocity.x
