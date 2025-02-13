extends CharacterBody2D

var SPEED = 40
@export var direction = 1
var inside_ray = false

@onready var ray: Sprite2D = $Ray
@onready var player = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $killzone
@onready var ray_collision: CollisionShape2D = $killzone/RayCollision
@onready var timer_to_turn: Timer = $TimerToTurn


func _process(delta: float) -> void:
     position.x += direction * SPEED * delta



func _ready() -> void:
 ray.modulate = Color("#FFD368")
 ray.modulate.a = 0.5
 if get_node_or_null("/root/level4/player") != null:
  player = get_node("/root/level4/player")
 elif get_node_or_null("/root/level6/player") != null:
  player = get_node("/root/level6/player")
 if direction == -1:
     animated_sprite_2d.scale.x = -1
     ray.position.x *= -1
     ray_collision.position.x *= -1
     ray.flip_h = true
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


func _on_marker_checker_area_entered(area: Area2D) -> void:
    if area.is_in_group("Marker"):
        SPEED=0
        timer_to_turn.start()

func _on_timer_to_turn_timeout() -> void:
        SPEED=40
        direction=direction*-1
        animated_sprite_2d.scale.x*=-1
        ray.position.x*=-1
        ray_collision.position.x*=-1
        if direction==-1:
            ray.flip_h=true
        else:
            ray.flip_h=false
