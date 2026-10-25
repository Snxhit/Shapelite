extends Camera2D

@export var player: Node2D
@export var smooth_speed: float = 5.0

func _physics_process(dt: float) -> void:
	if player:
		global_position = global_position.lerp(player.global_position, smooth_speed * dt)
