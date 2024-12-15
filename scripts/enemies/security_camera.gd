extends Node2D

var inside_ray = false
@onready var ray: Sprite2D = $Ray
@onready var player = get_node("/root/level4/player")

func _ready() -> void:
 ray.modulate = Color("#FFD368")
 ray.modulate.a = 0.5

func _physics_process(_delta: float) -> void:
    if inside_ray and not player.is_sneaking:
        ray.modulate = Color(1, 0, 0, 0.5)
    else:
        ray.modulate = Color("#FFD368")
        ray.modulate.a = 0.5

func _on_killzone_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        inside_ray = true

func _on_killzone_body_exited(body: Node2D) -> void:
    if body.is_in_group("Player"):
        inside_ray = false
