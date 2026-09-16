extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position
		
func die() -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	
	
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		print("collided with: ", collider)
		if collider is TileMapLayer:
			var coords: Vector2i = collider.get_coords_for_body_rid(collision.get_collider_rid())
			print("Tile coords: ", coords)
			var tile_data: TileData = collider.get_cell_tile_data(coords)
			print("Tile data: ", tile_data)
			if tile_data and tile_data.get_custom_data("hazard"):
				print("HAZARD HIT")
				die()
