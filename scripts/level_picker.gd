extends Control
@onready var level1=$MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Level1
@onready var level2=$MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Level2
@onready var level3=$MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Level3
@onready var level4=$MarginContainer/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Level4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    LevelState.reset_checkpoint()




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
    if SaveState.save_dict["level4Unlocked"]:
        level4.visible=true
    else:
        level4.visible=false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _on_quit_main_menu_pressed() -> void:
    SoundManager.play_sound("menuAccept",-20)
    get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")


func _on_level_1_pressed() -> void:
   SoundManager.play_sound("menuAccept",-20)
   get_tree().change_scene_to_file("res://scenes/cutscene/level1/level1_IntroCutscene.tscn")


func _on_level_2_pressed() -> void:
   SoundManager.play_sound("menuAccept",-20)
   get_tree().change_scene_to_file("res://scenes/cutscene/level2/level2_IntroCutscene.tscn")


func _on_level_3_pressed() -> void:
  SoundManager.play_sound("menuAccept",-20)
  get_tree().change_scene_to_file("res://scenes/cutscene/level3/level3_IntroCutscene.tscn")



func _on_level_4_pressed() -> void:
    SoundManager.play_sound("menuAccept",-20)
    get_tree().change_scene_to_file("res://scenes/cutscene/level4/level4_IntroCutscene.tscn")
