extends Node2D

signal cut_back(amount: int)

@export var damage_cooldown_time := 0.5

var _can_hurt_player := true
var length := 0
var _last_segment : TentacleSegment

@onready var _grow_timer := $GrowTimer


func build_tentacle(new_length: int) -> void:
	length = new_length
	for x in length:
		await _add_segment()
	_start_grow_timer()


func _add_segment() -> TentacleSegment:
	var new_segment := preload("res://tentacle/tentacle_segments/segment.tscn").instantiate()
	if _last_segment:
		_last_segment.tip = false
		_last_segment.add_child(new_segment)
	else:
		add_child(new_segment)
	
	new_segment.severed.connect(_on_segment_severed.bind(new_segment))
	new_segment.hit_player.connect(_on_segment_hit_player)
	
	await create_tween()\
		.tween_property(new_segment, "position", Vector2(0, -12), 0.25)\
		.set_trans(Tween.TRANS_QUAD)\
		.finished
	# segment might be cut off already
	if is_instance_valid(new_segment):
		new_segment.start()
		_last_segment = new_segment
		return new_segment
	else:
		return null


func _start_grow_timer() -> void:
	_grow_timer.start(
		lerpf(5.0, 10.0, randf())
	)


func _on_segment_severed(new_tip: Node2D, severed_area: TentacleSegment) -> void:
	var severed_length := severed_area.length()
	length -= severed_length
	cut_back.emit(severed_length)
	
	if new_tip == self:
		# tentacle has been severed at root
		queue_free()
	else:
		severed_area.queue_free()
		new_tip.tip = true
		_last_segment = new_tip


func _on_segment_hit_player(player: Player) -> void:
	if _can_hurt_player:
		player.damage()
		_can_hurt_player = false
		await get_tree().create_timer(damage_cooldown_time).timeout
		_can_hurt_player = true


func _on_grow_timer_timeout() -> void:
	_add_segment()
	_start_grow_timer()
