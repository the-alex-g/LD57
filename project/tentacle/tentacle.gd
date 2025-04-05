extends Node2D


func build_tentacle(length: int, last_segment = null) -> void:
	if length > 0:
		if last_segment:
			build_tentacle(length - 1, _add_segment_to(last_segment, length == 1))
		else:
			build_tentacle(length - 1, _add_segment_to(last_segment, length == 1))


func _add_segment_to(previous_segment: TentacleSegment, is_tip: bool) -> TentacleSegment:
	var new_segment := preload("res://tentacle/tentacle_segments/segment.tscn").instantiate()
	new_segment.tip = is_tip
	if previous_segment:
		previous_segment.add_child(new_segment)
		new_segment.position.y -= 12
	else:
		add_child(new_segment)
	
	new_segment.severed.connect(_on_segment_severed.bind(new_segment))
	
	return new_segment


func _on_segment_severed(new_tip: Node2D, severed_area: TentacleSegment) -> void:
	if new_tip == self:
		# tentacle has been severed at root
		queue_free()
	else:
		severed_area.queue_free()
		new_tip.tip = true
