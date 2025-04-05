extends Node2D


func _ready() -> void:
	build_tentacle(8)


func build_tentacle(length: int, last_segment = null) -> void:
	if length > 0:
		if last_segment:
			build_tentacle(length - 1, _add_segment_to(last_segment, length == 1))
		else:
			build_tentacle(length - 1, _add_segment_to(last_segment, length == 1))


func _add_segment_to(previous_segment: Area2D, is_tip: bool) -> Area2D:
	var new_segment := preload("res://tentacle/tentacle_segments/segment.tscn").instantiate()
	new_segment.tip = is_tip
	if previous_segment:
		previous_segment.add_child(new_segment)
		new_segment.position.y -= 12
	else:
		add_child(new_segment)
	return new_segment
