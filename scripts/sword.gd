extends Area2D
@export var damage : int=3


func _on_body_entered(body: Node2D) -> void:
    for child in body.get_children():
     if child is Damageable:
      child.hit(damage)




func start_attack():
    monitoring = true  # Enable collision monitoring


func end_attack():
    monitoring = false  # Disable collision monitoring
