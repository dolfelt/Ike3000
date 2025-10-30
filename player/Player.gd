extends CharacterBody2D

const SPEED = 200.0

var move_direction: Vector2 = Vector2.ZERO

var WeaponNode = preload("res://player/weapon.tscn")

@onready var weaponTimer = $WeaponTimer
var canFireWeapon: bool = true;

func _process(delta: float) -> void:
	if MultiplayerInput.is_action_pressed(0, "ui_fire", true) and canFireWeapon:
		_do_weapon()

func _input(event: InputEvent) -> void:
	move_direction.x = MultiplayerInput.get_axis(0, "ui_left", "ui_right")
	move_direction.y = MultiplayerInput.get_axis(0, "ui_up", "ui_down")


func _do_weapon() -> void:
	canFireWeapon = false
	weaponTimer.start()
	var weapon:Area2D = WeaponNode.instantiate()
	weapon.global_position = global_position
	get_parent().add_child(weapon)
	
	

func _handle_movement(delta, speed = SPEED):
	if move_direction.x:
		velocity.x = lerp(velocity.x, move_direction.x * speed, 0.2 * delta * 30.0)

		# if velocity.x > 0:
		# 	character.scale.x = 1
		# 	blockPickBox.scale.x = 1
		# elif velocity.x < 0:
		# 	character.scale.x = -1
		# 	blockPickBox.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if move_direction.y:
		velocity.y = lerp(velocity.y, move_direction.y * speed, 0.2 * delta / (1 / 60.0))
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

func _physics_process(delta: float) -> void:   
	_handle_movement(delta)
	move_and_slide()


func _on_weapon_timer_timeout() -> void:
	canFireWeapon = true
