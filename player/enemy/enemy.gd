extends CharacterBody2D

const SPEED = 75.0
const ACCELERATION = 800.0
const FRICTION = 900.0

@export var PlayerID: int = 0
@export var Type: String = "basic"

var player: CharacterBody2D

var move_direction: Vector2 = Vector2.ZERO

var WeaponNode = preload("res://player/weapon.tscn")

@onready var shipSprite:Sprite2D = $Ship
@onready var weaponTimer = $WeaponTimer
var canFireWeapon: bool = true;

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	shipSprite.region_rect.position.x = 32*PlayerID

func _do_weapon() -> void:
	canFireWeapon = false
	weaponTimer.start()
	var weapon:Area2D = WeaponNode.instantiate()
	weapon.position = position
	get_parent().add_child(weapon)

func _physics_process(delta: float) -> void:   
	var movement = Vector2(0,SPEED*delta)
	
	if player:
		movement.x = position.direction_to(player.position).x * SPEED * delta
	
	move_and_collide(movement)
	shipSprite.rotation = lerp_angle(shipSprite.rotation, movement.angle() - 1.5708, delta * SPEED/3)
	#rotate_toward(rotation, movement.angle(), SPEED*delta)

func _on_weapon_timer_timeout() -> void:
	canFireWeapon = true
	if player != null:
		shoot()

func shoot(): 
	if canFireWeapon:
		_do_weapon()


func _on_detection_body_entered(body: Node2D) -> void:
	print("DETECT", body, body is Player)
	if body is Player:
		player = body

	
