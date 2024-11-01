extends Node2D

var save_dict={
    "level1Unlocked":false,
    "level2Unlocked":false,
    "level3Unlocked":false,
    "playerProjectileUnlocked":true,
    "playerProjectileBombUnlocked":false,
 }

func _ready():
    load_game()
func save():
 return save_dict
func save_game():
 var save_game = FileAccess.open('user://savegame.save', FileAccess.WRITE)
 var json_string = JSON.stringify(save())
 save_game.store_line(json_string)

func load_game():
 if not FileAccess.file_exists("user://savegame.save"):
    return
 var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
 while save_game.get_position() < save_game.get_length():
    var json_string = save_game.get_line()
    var json= JSON.new()
    var parse_result=json.parse(json_string)
    save_dict=json.get_data()
func levelUnlock(level: int):
    save_dict["level" + str(level) + "Unlocked"] = true
    save()
    save_game()

func levelLock(level: int):
    save_dict["level" + str(level) + "Unlocked"] = false
    save()
    save_game()
func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:  # When game is closing
        save_game()
        get_tree().quit()
