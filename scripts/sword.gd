extends Area2D
@export var damage : int=300
@onready var audio_stream_player_2d_sword: AudioStreamPlayer2D = $AudioStreamPlayer2D_sword


func _on_body_entered(body: Node2D) -> void:
    for child in body.get_children():
     if child is Damageable:
      child.hit(damage)






func start_attack():
    monitoring = true  # Enable collision monitoring
    audio_stream_player_2d_sword.play()


func end_attack():
    monitoring = false  # Disable collision monitoring
