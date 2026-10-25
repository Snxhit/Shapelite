extends Resource
class_name EnemyData

@export var name: String = "Enemy"
@export var max_health: int = 10
@export var speed: int = 300
@export var texture: Texture2D
@export var projectile_data: ProjectileData
@export var collision_shape: PackedScene
