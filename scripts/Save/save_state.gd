extends Node2D

var save_dict={
    "level1Unlocked":false,
    "level2Unlocked":false,
    "level3Unlocked":false,
    "level4Unlocked":false,
    "playerProjectileUnlocked":true,
    "playerProjectileBombUnlocked":false,
    "playerProjectileAreaBlastUnlocked":false
 }
var current_checkpoint: Vector2
func _ready():
    print(OS.get_user_data_dir())
    load_game()
func save():
 return save_dict
func save_game():
 var save_game = FileAccess.open('user://savegame.save', FileAccess.WRITE)
 var json_string = JSON.stringify(save())
 save_game.store_line(json_string)

func load_game():
 if not FileAccess.file_exists("user://savegame.save"):
    levelUnlock(1)
    return
 var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
 while save_game.get_position() < save_game.get_length():
    var json_string = save_game.get_line()
    var json= JSON.new()
    var parse_result=json.parse(json_string)
    save_dict=json.get_data()

func levelUnlock(level: int):
    save_dict["level" + str(level) + "Unlocked"] = true
    if level==2: #weapon unlocks depending on level
        weaponUnlock("playerProjectileAreaBlastUnlocked")
    if level==4: #weapon unlocks depending on level
        weaponUnlock("playerProjectileBombUnlocked")
    save()
    save_game()

func levelLock(level: int):
    save_dict["level" + str(level) + "Unlocked"] = false
    save()
    save_game()

func resetLevels():
    for key in save_dict.keys():
     if key.begins_with("level"):
      save_dict[key] = false
    levelUnlock(1)
    resetWeapons()
    save()
    save_game()

func weaponUnlock(weapon: String):
    save_dict[weapon]=true;

func resetWeapons():
    for key in save_dict.keys():
     if key.begins_with("player"):
      save_dict[key] = false
    weaponUnlock("playerProjectileUnlocked")
    save()
    save_game()
func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:  # When game is closing
        save_game()
        get_tree().quit()
