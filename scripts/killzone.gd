extends Area2D
@onready var timer: Timer = $Timer
@onready var damage_again: Timer = $damage_again
@onready var Player = preload("res://scenes/player.tscn")
var inside_damage_zone : bool=false
var player_in_area: Node2D = null
func _on_body_entered(body: Node2D) -> void:
 if body.is_in_group("Player"):
  if !body.is_dead:
    player_in_area=body
    inside_damage_zone=true
    body.take_damage(1)
    print("player inside")
    player_in_area=body
    damage_again.start()
    if body.health<= 0:
        damage_again.stop()
        timer.start()



func _on_body_exited(body: Node2D) -> void:
   inside_damage_zone=false
# Called when the timer times out
func _on_timer_timeout() -> void:
    get_tree().reload_current_scene()  # Reload the current scene



func _on_damage_again_timeout() -> void:

    if inside_damage_zone==true:
         player_in_area.take_damage(1)
         if player_in_area.health<= 0:
          damage_again.stop()
          timer.start()
