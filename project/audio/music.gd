extends Node

var _goblin_bus_index := AudioServer.get_bus_index("Goblin")
var _music_bus_index := AudioServer.get_bus_index("Music")
var _sfx_bus_index := AudioServer.get_bus_index("SFX")

@onready var _drum_player := $Drum
@onready var _goblin_player := $Goblin
@onready var _main_player := $Main
@onready var _fizz_player := $Fizz


func _ready() -> void:
	_drum_player.play()
	_goblin_player.play()
	_main_player.play()
	update_corruption(0.0)


func update_corruption(percent_corrupted: float) -> void:
	var volume := lerpf(-36.0, 0.0, sin(percent_corrupted * PI / 2.0))
	AudioServer.set_bus_volume_db(_goblin_bus_index, volume)


func set_music_mute(value: bool) -> void:
	AudioServer.set_bus_mute(_music_bus_index, value)


func set_sfx_mute(value: bool) -> void:
	AudioServer.set_bus_mute(_sfx_bus_index, value)


func play_fizz() -> void:
	_fizz_player.play()
