class_name Hitbox extends Area2D

@export var damage: int = 1
@export var knockback_strength: float = 200.0
@export var knockback_direction: Vector2 = Vector2.ZERO
@export var stores_hit_targets: bool = false

var hit_targets: Array

func clear_hit_targets() -> void:
	hit_targets.clear()
