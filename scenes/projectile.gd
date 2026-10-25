extends Area2D

@export var data: ProjectileData

func _ready() -> void:
	if data:
		$Sprite2D.texture = data.texture
		collision_mask = data.collision_mask

func _process(dt: float) -> void:
	position += transform.x * data.speed * dt
	
func _on_screen_exit():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(data.dmg, global_position)
		$HitSound.play()

func _on_hit_sound_finished() -> void:
	queue_free()
