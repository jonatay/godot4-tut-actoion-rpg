class_name BatEnemy extends CharacterBody2D

@export var max_detect_range: float = 100.0
@export var min_detect_range: float = 4.0

@export var stats: Stats

var ENEMY_DEATH_EFFECT: PackedScene = preload("uid://c4gfyejxgkf6q")
var HIT_EFFECT: PackedScene = preload("uid://cpcl80cmvbs7q")

const SPEED = 30.0
const FRICTION = 500.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var center: Marker2D = $Center
@onready var navigation_agent_2d: NavigationAgent2D = $Marker2D/NavigationAgent2D
@onready var marker_2d: Marker2D = $Marker2D


func _ready() -> void:
	stats = stats.duplicate()
	hurtbox.hurt.connect(take_hit.call_deferred)
	stats.no_health.connect(die)

func die() -> void:
	var enemy_death_effect_instance = ENEMY_DEATH_EFFECT.instantiate()
	get_tree().current_scene.add_child(enemy_death_effect_instance)
	enemy_death_effect_instance.global_position = global_position
	queue_free()

func _physics_process(_delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState": pass
		"ChaseState":
			var player = get_player()
			if player is Player:
				navigation_agent_2d.target_position = player.global_position
				var next_point = navigation_agent_2d.get_next_path_position()
				velocity = global_position.direction_to(next_point - marker_2d.position)*SPEED
			else:
				velocity = Vector2.ZERO
			# sprite_2d.flip_h = velocity.x < 0
			sprite_2d.scale.x = sign(velocity.x)
			move_and_slide()
		"HitState":
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * _delta)
			move_and_slide()

func take_hit(hitbox: Hitbox) -> void:
	stats.health -= hitbox.damage
	velocity = hitbox.knockback_direction * hitbox.knockback_strength
	playback.start("HitState")

	var hit_effect_instance =HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(hit_effect_instance)
	hit_effect_instance.global_position = center.global_position

	# print("BatEnemy hurt!")
	# var hit_effect_instance = HIT_EFFECT.instantiate()
	# get_tree().current_scene.add_child(hit_effect_instance)
	# hit_effect_instance.global_position = global_position

	# var enemy_death_effect_instance = ENEMY_DEATH_EFFECT.instantiate()
	# get_tree().current_scene.add_child(enemy_death_effect_instance)
	# enemy_death_effect_instance.global_position = global_position
	# queue_free()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player") 

func is_player_in_range() -> bool:
	var result = false
	var player = get_player()
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < max_detect_range and distance_to_player > min_detect_range:
			result = true
	return result

func can_see_player() -> bool:
	if not is_player_in_range():
		return false

	var player = get_player()
	ray_cast_2d.target_position = (player.global_position - global_position)
	ray_cast_2d.force_raycast_update()
	var has_los_to_player = ray_cast_2d.is_colliding()
	return has_los_to_player


	#var result = false
	#ray_cast_2d.target_position = to_local(get_player().global_position)
	#ray_cast_2d.force_raycast_update()
	#if ray_cast_2d.is_colliding():
		#var collider = ray_cast_2d.get_collider()
		#if collider is Player:
			#result = true
	#return result
