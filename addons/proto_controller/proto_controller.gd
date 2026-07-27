extends CharacterBody2D

@export var speed = 150.0
@export var jump_velocity = -300.0

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
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			# 1. Only push if we are on the floor (prevents mid-air flying glitches)
			# 2. Only push if hitting the flat sides (> 0.9)
			if is_on_floor() and abs(collision.get_normal().x) > 0.9:
				
				var push_force = 20.0 
				var push_direction = -collision.get_normal().x
				
				collider.apply_central_impulse(Vector2(push_direction * push_force, 0))
				
				# Break out of the loop immediately so it only pushes ONCE per frame
				break
		if collider.is_in_group("deadly"):
			get_parent().get_parent().restart()
			
