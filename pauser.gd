class_name Pauser extends Node

@onready var pause_audio_stream_player: AudioStreamPlayer = $PauseAudioStreamPlayer
@onready var un_pause_audio_stream_player: AudioStreamPlayer = $UnPauseAudioStreamPlayer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		# print("Pause toggled")
		if get_tree().paused:
			un_pause_audio_stream_player.play()
		else:
			pause_audio_stream_player.play()
		get_tree().paused = not get_tree().paused
