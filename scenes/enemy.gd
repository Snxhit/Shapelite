extends CharacterBody2D

var speed = 200.0
var max_health = 10
var health = max_health
@export var projectile_scene: PackedScene
var projectile_data: ProjectileData
@export var dmg_number_scene: PackedScene
@export var data: EnemyData

var chase_player: bool = false
var shoot_player: bool = false

func _ready() -> void:
	if data:
		$Sprite2D.texture = data.texture
		max_health = data.max_health
		health = max_health
		speed = data.speed
		projectile_data = data.projectile_data
		add_child(data.collision_shape.instantiate())
	
	$HealthBar.min_value = 0.0
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar.hide()
	$HealthBar.pivot_offset = $HealthBar.size / 2

func _physics_process(delta: float) -> void:
	if chase_player:
		velocity = global_position.direction_to(get_parent().get_node("Player").global_position) * speed
		if global_position.distance_to(get_parent().get_node("Player").global_position) < 20.0:
			chase_player = false
			velocity = Vector2.ZERO
		move_and_slide()
	if shoot_player:
		shoot()

func shoot():
	if $ShootTimer.is_stopped():
		var proj = projectile_scene.instantiate()
		proj.data = projectile_data
		get_tree().root.add_child(proj)
		proj.global_position = global_position
		proj.look_at(get_parent().get_node("Player").global_position)
		var sSound = proj.get_node("ShootSound")
		sSound.pitch_scale = randf_range(0.6, 1.5)
		sSound.play()
		$ShootTimer.start()

func take_damage(dmg: int, pos: Vector2):
	health -= dmg
	if health <= 0:
		queue_free()
		return

	$HealthBar.value = health
	$HPBarTimer.stop()
	$HPBarTimer.start()
	
	var hb_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if not $HealthBar.visible:
		$HealthBar.show()
		$HealthBar.scale = Vector2(0.8, 0.8)
		$HealthBar.modulate.a = 0.0
	
	hb_tween.tween_property($HealthBar, "scale", Vector2(1.0, 1.0), 0.15)
	hb_tween.tween_property($HealthBar, "modulate:a", 1.0, 0.15)
	
	var tween = create_tween().set_parallel(true)
	$Sprite2D.modulate = Color(9.999, 6.473, 6.473, 1.0)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.2)
	$Sprite2D.scale = Vector2(1.2, 0.8)
	tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	DmgNumberManager.display_number(dmg, pos + Vector2(randi_range(1, 10), randi_range(1, 10)))

func _on_timer_timeout() -> void:
	var dist = global_position.distance_to(get_parent().get_node("Player").global_position)
	chase_player = dist < 1500.0 and dist > 1000.0
	shoot_player = dist > 1000.0

func _on_hp_bar_timer_timeout() -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property($HealthBar, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_property($HealthBar, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback($HealthBar.hide)
