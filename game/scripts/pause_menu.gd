
extends Control

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    print("Pause menu ready")

func _on_play_pressed() -> void:
    print("Play pressed")
    get_tree().paused = false
    hide()

func _on_exit_pressed() -> void:
    SoundManager.play_sound("menuAccept",-10)
    print("Exit pressed")
    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")
