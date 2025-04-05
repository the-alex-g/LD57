extends Area2D

var tip := false

@onready var _sprite := $AnimatedSprite2D
@onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	if tip:
		_sprite.play("tip")
	
	_animation_player.speed_scale = lerpf(0.5, 1.0, randf())
	_animation_player.seek(randf() * 2.0)
