extends CharacterBody2D
@export var health: float = 1

@onready var area_2d: Area2D = $"../LevelEnd/Area2D"



func _physics_process(delta: float) -> void:
 if health <=0:
    area_2d.monitoring=true
