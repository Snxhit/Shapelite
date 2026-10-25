extends Marker2D

func _ready():
	var tween = create_tween()
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position:y", position.y - 30, 0.2)
	tween.tween_interval(0.1)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "rotation_degrees", 720, 0.7)
	tween.parallel().tween_property(self, "modulate:a", 0, 0.7)
	tween.parallel().tween_property(self, "position:y", position.y - 60, 0.7)
	tween.tween_callback(queue_free)

func set_text(text: String):
	$Label.text = text
	await get_tree().process_frame 
	$Label.pivot_offset = $Label.size / 2
	$Label.position = -$Label.size / 2
