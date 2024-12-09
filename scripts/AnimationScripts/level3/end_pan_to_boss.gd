extends Area2D

@onready var anim_player = $AnimationPlayerEndPanToBoss
@onready var player=$"../player"
@onready var inputStopTimer=$inputStopTimer

var timerTriggerable = true

func _on_input_stop_timer_timeout() -> void:
    player.set_physics_process(true)
    timerTriggerable = false
    SaveState.levelUnlock(4)
    get_tree().change_scene_to_file("res://scenes/cutscene/level3/level3_OutroCutscene.tscn")






func _on_area_2d_body_entered(body: Node2D) -> void:
  if timerTriggerable and body.is_in_group("Player"):
    inputStopTimer.start()
    print("up")
    player.set_physics_process(false)
    anim_player.play(self.name)
