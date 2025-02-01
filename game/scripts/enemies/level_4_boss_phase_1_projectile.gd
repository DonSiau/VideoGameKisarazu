extends CharacterBody2D
@export var health: float = 6  # Health variable defined in the enemy node
var SPEED = 75  # Speed of the enemy
var player_pos: Vector2  # Position of the player
var target_pos: Vector2  # Direction towards the player
@onready var expire_projectile: Timer = $ExpireProjectile

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().get_node("player")  # Reference to the Player node
func _ready() -> void:
    expire_projectile.start()

func _physics_process(delta: float) -> void:
    if player:  #
        player_pos = player.position  # Get the player's position
        target_pos = (player_pos - position).normalized()  # Calculate the direction towards the player

        if position.distance_to(player_pos) <500:
            position += target_pos * SPEED * delta  # Update the position manually based on speed and delta




func _on_expire_projectile_timeout() -> void:
    queue_free()


func _on_killzone_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        queue_free()
