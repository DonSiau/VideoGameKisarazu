extends Area2D
@onready var audio_stream_player_bg: AudioStreamPlayer = $"../AudioStreamPlayerBG"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var initiated=false
func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player") and  not initiated:
        initiated=true
        body.is_depowered=false
        print("entered")
        audio_stream_player_bg.stream=load("res://DialogicStuff/Audio/music/Level4/bossFight1.ogg")
        audio_stream_player_bg.play()
        animation_player.play("boss initiation")
