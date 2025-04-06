extends Node

var _goblin_bus_index := AudioServer.get_bus_index("Goblin")
var _music_bus_index := AudioServer.get_bus_index("Music")

@onready var _drum_player := $Drum
@onready var _goblin_player := $Goblin
@onready var _main_player := $Main


func _ready() -> void:
	_drum_player.play()
	_goblin_player.play()
	_main_player.play()
	update_corruption(0.0)


func update_corruption(percent_corrupted: float) -> void:
	var volume := lerpf(-36.0, 0.0, sin(percent_corrupted * PI / 2.0))
	AudioServer.set_bus_volume_db(_goblin_bus_index, volume)


func set_mute(value: bool) -> void:
	AudioServer.set_bus_mute(_music_bus_index, value)
