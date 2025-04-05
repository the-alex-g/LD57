class_name TentacleSegment
extends Area2D

enum SegmentType {TIP, BODY, BASE}

signal severed(new_tip: Node2D)
signal hit_player(player: Player)
signal drop_bubbles(bubble_transform: Transform2D)

var type := SegmentType.TIP : set = set_type
var reversed := false : set = set_reversed

@onready var _sprite := $AnimatedSprite2D
@onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	rotation = 0.0


func start() -> void:
	_animation_player.play("wave", -1, lerpf(0.5, 1.0, randf()), randi() % 2 == 0)


func sever() -> void:
	severed.emit(get_parent())
	propagate_drop_bubbles()


func propagate_drop_bubbles() -> void:
	drop_bubbles.emit(global_transform)
	var next_segment := get_next_segment()
	if next_segment:
		next_segment.propagate_drop_bubbles()


func get_next_segment() -> TentacleSegment:
	if get_child_count() == 4:
		return get_child(3)
	else:
		return null


func set_type(value: SegmentType) -> void:
	type = value
	if is_node_ready():
		match type:
			SegmentType.TIP:
				_sprite.play("tip")
			SegmentType.BODY:
				_sprite.play("body")
			SegmentType.BASE:
				_sprite.play("base")
	else:
		await tree_entered
		set_type(value)


func set_reversed(value: bool) -> void:
	reversed = value
	if is_node_ready():
		_sprite.flip_h = value
	else:
		await tree_entered
		set_reversed(value)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		hit_player.emit(body)


func length() -> int:
	var next_segment := get_next_segment()
	if next_segment:
		return 1 + next_segment.length()
	else:
		return 1
