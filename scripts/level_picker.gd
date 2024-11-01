extends Control
@onready var level1=$MarginContainer/VBoxContainer/Level1
@onready var level2=$MarginContainer/VBoxContainer/Level2
@onready var level3=$MarginContainer/VBoxContainer/Level3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    SaveState.levelUnlock(1)
    SaveState.levelUnlock(2)
    SaveState.levelUnlock(3)

    if SaveState.save_dict["level1Unlocked"]:
        level1.visible=true
    else:
        level1.visible=false
    if SaveState.save_dict["level2Unlocked"]:
        level2.visible=true
    else:
        level2.visible=false
    if SaveState.save_dict["level3Unlocked"]:
        level3.visible=true
    else:
        level3.visible=false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_quit_main_menu_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")


func _on_level_1_pressed() -> void:
   get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")


func _on_level_2_pressed() -> void:
   get_tree().change_scene_to_file("res://scenes/levels/level2.tscn")


func _on_level_3_pressed() -> void:
  get_tree().change_scene_to_file("res://scenes/levels/level3.tscn")
