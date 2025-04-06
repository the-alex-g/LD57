extends Node2D

signal cut_back(amount: int)
signal drop_bubbles(bubble_transform: Transform2D)

@export var damage_cooldown_time := 0.5

var _can_hurt_player := true
var length := 0
var _last_segment : TentacleSegment
var _reversed := randi() % 2 == 0
var _growing := true

@onready var _grow_timer := $GrowTimer


func build_tentacle(new_length: int) -> void:
	length = new_length
	for x in length:
		if _growing:
			await _add_segment()
	_start_grow_timer()
	_growing = false


func _add_segment() -> TentacleSegment:
	var new_segment := preload("res://tentacle/tentacle_segments/segment.tscn").instantiate()
	var target := -12
	if _last_segment:
		if _last_segment.type != TentacleSegment.SegmentType.BASE:
			_last_segment.type = TentacleSegment.SegmentType.BODY
		_last_segment.add_child(new_segment)
	else:
		add_child(new_segment)
		new_segment.type = TentacleSegment.SegmentType.BASE
		target = -4
	new_segment.reversed = _reversed
	
	new_segment.severed.connect(_on_segment_severed.bind(new_segment))
	new_segment.hit_player.connect(_on_segment_hit_player)
	new_segment.drop_bubbles.connect(_on_segment_drop_bubbles)
	
	await create_tween()\
		.tween_property(new_segment, "position", Vector2(0, target), 0.25)\
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
	
	if length <= 2:
		# tentacle has been severed at root
		queue_free()
	else:
		severed_area.queue_free()
		new_tip.type = TentacleSegment.SegmentType.TIP
		_last_segment = new_tip
	Music.play_fizz()


func _on_segment_hit_player(player: Player) -> void:
	if _can_hurt_player:
		player.damage()
		_can_hurt_player = false
		await get_tree().create_timer(damage_cooldown_time).timeout
		_can_hurt_player = true


func _on_segment_drop_bubbles(bubble_transform: Transform2D) -> void:
	drop_bubbles.emit(bubble_transform)


func _on_grow_timer_timeout() -> void:
	_add_segment()
	_start_grow_timer()


func game_over(win: bool) -> void:
	_growing = false
	if win:
		_grow_timer.stop()
		var first_segment : TentacleSegment = get_child(1)
		first_segment.propagate_drop_bubbles()
		first_segment.queue_free()
