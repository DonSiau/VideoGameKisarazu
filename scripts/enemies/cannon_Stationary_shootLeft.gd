extends Node2D

const SPEED = 40
var direction = 1
@onready var projectile_barrel_Left = $projectile_barrel_Left
@onready var Projectile = preload("res://scenes/enemyProjectile.tscn")
@export var health: float = 9  # Health variable defined in the enemy node
@onready var reload: Timer = $reload
@onready var sprite2d: Sprite2D = $Sprite2D


func _ready() -> void:
 pass
func _process(delta: float) -> void:
    pass


func _on_reload_timeout() -> void:

        var projectile = Projectile.instantiate()
        if projectile:
            get_tree().current_scene.add_child(projectile)

            var direction: Vector2
            var active_barrel: Node2D
            active_barrel = projectile_barrel_Left
            direction = Vector2.LEFT


            # Set the position to the active barrel's global position
            projectile.global_position = active_barrel.global_position
            projectile.launch(direction)
