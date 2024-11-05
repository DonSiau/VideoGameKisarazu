extends Node2D
func _ready() -> void:
    pass

func _process(delta: float) -> void:
    pass

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        var levelNumber=int(str(get_parent().name)[5])+1
        print(levelNumber)
        if levelNumber < 4: #change values if there are more than 3 levels
         SaveState.levelUnlock(levelNumber)
         SaveState.load_game()
         get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")
        else:
         SaveState.levelUnlock(3)
         SaveState.load_game()
         get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")
