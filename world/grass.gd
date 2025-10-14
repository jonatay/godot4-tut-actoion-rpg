extends Node2D

#const GRASS_EFFECT = preload("res://effects/grass_effect.tscn")
@export var GRASS_EFFECT: PackedScene

@onready var hurtbox: Hurtbox = $Hurtbox

# called when node entres the scene tree 1st time
func _ready() -> void:
	hurtbox.hurt.connect(_on_hurtbox_hurt)

func _on_hurtbox_hurt(_other_hitbox: Hitbox) -> void:
	var grass_effect_instance = GRASS_EFFECT.instantiate()
	get_tree().current_scene.add_child(grass_effect_instance)
	grass_effect_instance.global_position = global_position
	queue_free()
