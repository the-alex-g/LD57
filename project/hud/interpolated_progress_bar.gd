extends ProgressBar

@export var trans_type : Tween.TransitionType = Tween.TRANS_QUAD


func interpolate_value(target: float, duration: float) -> void:
	create_tween() \
		.tween_property(self, "value", target, duration) \
		.set_trans(trans_type)
