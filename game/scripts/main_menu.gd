extends Control
@onready var audio_stream_player_2d_menu_accept: AudioStreamPlayer2D = $AudioStreamPlayer2D_MenuAccept


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
   SaveState.load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_play_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")
    SoundManager.play_sound("menuAccept",-20)


func _on_exit_pressed() -> void:
    SoundManager.play_sound("menuAccept",-20)
    SaveState.save_game()
    get_tree().quit()


func _on_reset_pressed() -> void:
    SoundManager.play_sound("menuAccept",-20)
    SaveState.resetLevels()
    SaveState.resetWeapons()
