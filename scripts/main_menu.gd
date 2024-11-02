extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
   SaveState.load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_play_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")


func _on_exit_pressed() -> void:
    SaveState.save_game()
    get_tree().quit()
