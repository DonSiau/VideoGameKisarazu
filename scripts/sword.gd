extends Area2D
@export var damage : int=3



func _on_body_entered(body: Node2D) -> void:
    print("Body entered: ", body.name)
    for child in body.get_children():
     if child is Damageable:
      child.hit(damage)
     else:
        print("No Damageable node found")


func start_attack():
    monitoring = true  # Enable collision monitoring


func end_attack():
    monitoring = false  # Disable collision monitoring
