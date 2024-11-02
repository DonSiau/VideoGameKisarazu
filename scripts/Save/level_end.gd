extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        var levelNumber=int(str(get_parent().name)[5])+1
        print(levelNumber)
        if levelNumber < 4: #change values if there are more than 3 levels
         SaveState.levelUnlock(levelNumber)
         SaveState.load_game()
        else:
         SaveState.levelUnlock(3)
         SaveState.load_game()
    get_tree().change_scene_to_file("res://scenes/menus/LevelPicker.tscn")
