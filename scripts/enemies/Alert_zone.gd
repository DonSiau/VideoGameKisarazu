extends Area2D
@onready var timer: Timer = $Timer
@onready var damage_again: Timer = $damage_again
@onready var player = get_node("/root/level4/player")
var inside_damage_zone : bool=false
var player_in_area: Node2D = null
@onready var ray: Sprite2D = $"../ray"

@onready var shrubtooth: CharacterBody2D = $".."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"


func _physics_process(delta: float) -> void:
    if shrubtooth.enraged:
        ray.modulate = Color(1, 0, 0, 0.5)
    else:
        ray.modulate = Color("#FFD368")
        ray.modulate.a = 0.5

func _on_body_entered(body: Node2D) -> void:
 if body.is_in_group("Player"):
  if not body.is_dead and not player.is_sneaking:
    player_in_area=body
    shrubtooth.enraged=true
    animated_sprite_2d.play("Shrubtooth_enraged")




func _on_body_exited(body: Node2D) -> void:
   shrubtooth.enraged=false
   animated_sprite_2d.play("Shrubtooth_walk")
# Called when the timer times out
func _on_timer_timeout() -> void:
    get_tree().reload_current_scene()  # Reload the current scene



func _on_damage_again_timeout() -> void:

    if inside_damage_zone==true:
         player_in_area.take_damage(0.25)
         if player_in_area.health<= 0:
          damage_again.stop()
          timer.start()
