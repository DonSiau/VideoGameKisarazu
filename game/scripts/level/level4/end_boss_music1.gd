extends Area2D
@onready var audio_stream_player_bg: AudioStreamPlayer = $"../AudioStreamPlayerBG"


func _on_body_entered(body: Node2D) -> void:
 if body.is_in_group("Player"):
    audio_stream_player_bg.stream=load("res://DialogicStuff/Audio/music/Level4/Sketchbook 2024-07-04.ogg")
    audio_stream_player_bg.play()
