class_name TentacleSegment
extends Area2D

signal severed(new_tip)
signal hit_player(player)

var tip := false : set = set_tip

@onready var _sprite := $AnimatedSprite2D
@onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	set_tip(tip)
	
	_animation_player.speed_scale = lerpf(0.5, 1.0, randf())
	_animation_player.seek(randf() * 2.0)


func sever() -> void:
	severed.emit(get_parent())


func set_tip(value: bool) -> void:
	tip = value
	if is_node_ready():
		_sprite.play("tip" if value else "body")
	else:
		await tree_entered
		set_tip(value)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hit_player.emit(body)
