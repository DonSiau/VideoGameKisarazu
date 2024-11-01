extends Area2D

@onready var projectile_timeout = $Projectile_timeout
@export var damage: int = 3
const MOVE_SPEED = 180
var GRAVITY = 800
var velocity = Vector2.ZERO

@onready var kill_zone = $bombKillzone

func launch(direction: Vector2):
    velocity.x = direction.x * MOVE_SPEED
    velocity.y = -170
    $Projectile_timeout.start()

func _ready():

    if kill_zone:
        kill_zone.monitoring = false


func _physics_process(delta: float) -> void:
    if velocity != Vector2.ZERO:
        velocity.y += GRAVITY * delta
        position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
    $Sprite2D.visible=false
    $AnimatedSprite2D.play("explosion")
    if body.is_in_group("Player"):  # Skip if body is player
        return

    velocity = Vector2.ZERO
    if kill_zone:
        kill_zone.monitoring = true


    for child in body.get_children():
        if child is Damageable:
            child.hit(damage)

func _on_projectile_timeout_timeout() -> void:
    queue_free()
