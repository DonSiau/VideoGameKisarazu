extends Area2D
@export var damage : int=3


var player_in_area: Node2D = null  # To store the reference to the player
func _on_body_entered(body: Node2D) -> void:

     for child in body.get_children():
      if child is Damageable:
       print("hit")
       child.hit(damage)
