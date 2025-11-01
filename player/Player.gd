extends CharacterBody2D

const SPEED = 350.0
const ACCELERATION = 800.0
const FRICTION = 900.0

@export var PlayerID: int = 0

var move_direction: Vector2 = Vector2.ZERO

var WeaponNode = preload("res://player/weapon.tscn")

@onready var shipSprite:Sprite2D = $Ship
@onready var weaponTimer = $WeaponTimer
var canFireWeapon: bool = true;

func _process(delta: float) -> void:
	if MultiplayerInput.is_action_pressed(0, "ui_fire", true) and canFireWeapon:
		_do_weapon()

func _ready() -> void:
	shipSprite.region_rect.position.x = 32*PlayerID

func _input(event: InputEvent) -> void:
	move_direction.x = MultiplayerInput.get_axis(0, "ui_left", "ui_right")
	move_direction.y = MultiplayerInput.get_axis(0, "ui_up", "ui_down")


func _do_weapon() -> void:
	canFireWeapon = false
	weaponTimer.start()
	var weapon:Area2D = WeaponNode.instantiate()
	weapon.position = position
	get_parent().add_child(weapon)



func _handle_movement(delta, speed = SPEED):
	# Airship-style movement with momentum and drift

	if move_direction.length() > 0:
		# Accelerate in the direction of input
		var target_velocity = move_direction.normalized() * speed
		velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
	else:
		# Apply friction when no input (gradual drift to stop)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	#var camera: Camera2D = get_parent()
	var viewport: Rect2 = get_viewport_rect()
	var view_origin: Vector2 = viewport.position - Vector2(0, viewport.size.y)
	position = position.clamp(view_origin, view_origin + viewport.size)

	shipSprite.scale.x = max(0.8, 1 - abs(velocity.x / (SPEED*3)))

func _physics_process(delta: float) -> void:   
	_handle_movement(delta)
	move_and_slide()


func _on_weapon_timer_timeout() -> void:
	canFireWeapon = true
