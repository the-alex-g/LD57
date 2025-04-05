extends Node2D

@export var damage_cooldown_time := 0.5

var _can_hurt_player := true
var length := 0


func build_tentacle(new_length: int) -> void:
	length = new_length
	_create_tentacle_chain(length)


func _create_tentacle_chain(remaining_length: int, last_segment = null) -> void:
	if remaining_length > 0:
		_create_tentacle_chain(
			remaining_length - 1,
			_add_segment_to(last_segment, length == 1)
		)


func _add_segment_to(previous_segment: TentacleSegment, is_tip: bool) -> TentacleSegment:
	var new_segment := preload("res://tentacle/tentacle_segments/segment.tscn").instantiate()
	new_segment.tip = is_tip
	if previous_segment:
		previous_segment.add_child(new_segment)
		new_segment.position.y -= 12
	else:
		add_child(new_segment)
	
	new_segment.severed.connect(_on_segment_severed.bind(new_segment))
	new_segment.hit_player.connect(_on_segment_hit_player)
	
	return new_segment


func _on_segment_severed(new_tip: Node2D, severed_area: TentacleSegment) -> void:
	if new_tip == self:
		# tentacle has been severed at root
		queue_free()
	else:
		severed_area.queue_free()
		length -= severed_area.length()
		new_tip.tip = true


func _on_segment_hit_player(player: Player) -> void:
	if _can_hurt_player:
		player.damage()
		_can_hurt_player = false
		await get_tree().create_timer(damage_cooldown_time).timeout
		_can_hurt_player = true
