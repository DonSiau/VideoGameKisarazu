extends AnimatableBody2D
@onready var anim_player = $movingPlatformSetPiece
@onready var player=$"../../player"
@onready var inputStopTimer=$inputStopTimer
@onready var fogKillzone=$fog/fogKillzone
var timerTriggerable = true


func _on_area_2d_area_entered(area: Area2D) -> void:
   if timerTriggerable:
    fogKillzone.monitoring=true
    inputStopTimer.start()
    print("up")
    player.set_physics_process(false)
    anim_player.play(self.name)
    $fog.visible=true


func _on_input_stop_timer_timeout() -> void:
    player.set_physics_process(true)
    timerTriggerable = false
