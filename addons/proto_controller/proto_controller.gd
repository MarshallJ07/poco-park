extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity := 980
var gravDir := 1
func _physics_process(delta):
	if !is_multiplayer_authority():
		return
		
	# Add the gravity.
	if (not is_on_floor() and gravDir == 1) or (not is_on_ceiling() and gravDir == -1):
		velocity.y += gravity * gravDir * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and ((is_on_floor() and gravDir == 1) or (is_on_ceiling() and gravDir == -1)):
		velocity.y = jump_velocity * gravDir

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
