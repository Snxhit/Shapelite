extends CharacterBody2D

@export var speed = 500.0
@export var max_health = 100
var health = max_health
@export var projectile_scene: PackedScene
@export var projectile_data: ProjectileData
@export var dmg_number_scene: PackedScene

@onready var hpBar = $"../MainCamera/GameUI/HealthBar"

func _ready() -> void:
	hpBar.min_value = 0.0
	hpBar.max_value = max_health
	hpBar.value = max_health

func _input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		shoot()

func _physics_process(delta: float) -> void:
	var xdir := Input.get_axis("move_left", "move_right")
	if xdir:
		velocity.x = xdir * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	var ydir := Input.get_axis("move_up", "move_down")
	if ydir:
		velocity.y = ydir * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func take_damage(dmg: int, pos: Vector2):
	if health - dmg <= 0:
		print("player die")
	else:
		health = health - dmg
		hpBar.value = health
	var tween = create_tween().set_parallel(true)
	$Sprite2D.scale = Vector2(1.4, 0.6)
	tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	DmgNumberManager.display_number(dmg, pos + Vector2(randi_range(1, 10), randi_range(1, 10)))

func shoot():
	if $ShootTimer.is_stopped():
		var proj = projectile_scene.instantiate()
		proj.data = projectile_data
		get_tree().root.add_child(proj)
		proj.global_position = global_position
		proj.look_at(get_global_mouse_position())
		var sSound = proj.get_node("ShootSound")
		sSound.pitch_scale = randf_range(0.6, 1.5)
		sSound.playing = true
		$ShootTimer.start()
