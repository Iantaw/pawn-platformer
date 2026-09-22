extends CharacterBody2D
signal hit

@onready var hud = $"../HUD"
@onready var hud_headline = $"../HUD/Headline"
@onready var start_position = $"../StartPosition"

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

var is_dead: bool = false

func _ready() -> void:
	if not hud.start_game.is_connected(_on_start_game):
		hud.start_game.connect(_on_start_game)

func new_game() -> void:
	is_dead = false
	velocity = Vector2.ZERO
	global_position = start_position.global_position
	show()
	hud.hide()
	
func _physics_process(delta: float) -> void:
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_killzone_body_shape_entered(
	_body_rid: RID,
	body: Node2D,
	_body_shape_index: int,
	_local_shape_index: int
) -> void:
	if body != self:
		return
	
	_die()

func _die() -> void:
	hide()
	is_dead = true
	velocity = Vector2.ZERO
	hud_headline.text = "You Died!"
	hud.show()
	hit.emit()

func _on_win_body_entered(body: Node2D) -> void:
	if body != self:
		return
	
	hide()
	is_dead = true
	velocity = Vector2.ZERO
	hud_headline.text = "You Win!"
	hud.show()
	
func _on_start_game() -> void:
	new_game()
	
