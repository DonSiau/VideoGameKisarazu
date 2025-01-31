extends Node2D
@onready var audio_stream_player_bg: AudioStreamPlayer = $AudioStreamPlayerBG
func _ready() -> void:
    audio_stream_player_bg.stream
    audio_stream_player_bg.autoplay
