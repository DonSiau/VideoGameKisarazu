extends CharacterBody2D

const SPEED = 50
var direction = 1
@export var health: float = 120
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $"../Level4BossFightInitator/AnimationPlayer"


@onready var phase_1_projectile_reload: Timer = $phase1ProjectileReload
@onready var phase_2_projectile_reload: Timer = $phase2ProjectileReload

@onready var left_barrel: Marker2D = $LeftBarrel
@onready var right_barrel: Marker2D = $RightBarrel
var phase_1_projectile = preload("res://scenes/enemies/level4BossPhase1Projectile.tscn")
@onready var phase_2_projectile = preload("res://scenes/enemies/level4BossPhase2Projectile.tscn")
@onready var phase_2_node: Node2D = $phase2Node

@export var phase = 1
var phase_1_timer_started = false
var phase_2_timer_started = false
func _ready() -> void:
    position=Vector2(4320,-600)
    animated_sprite_2d.scale = Vector2(1, 1)
    var shader_material = ShaderMaterial.new()
    shader_material.shader = preload("res://shader/flashShader.gdshader")
    shader_material.set_shader_parameter("active", false)
    animated_sprite_2d.material = shader_material



func _process(delta: float) -> void:
    print(position)
    if health < 40:
        phase = 3
    elif health < 80:
        phase = 2


    if phase == 1:
        if not phase_1_timer_started:
            phase_1_projectile_reload.start()
            phase_1_timer_started = true
    elif phase == 2:
        if not phase_2_timer_started:
            phase_2_projectile_reload.start()
            phase_2_timer_started = true
    elif phase == 3:
        animation_player.play("phase3")

func _on_phase_1_projectile_reload_timeout() -> void:
    var projectile_instance = phase_1_projectile.instantiate()
    var left_projectile = projectile_instance.duplicate()
    left_projectile.global_position = left_barrel.global_position
    get_tree().current_scene.add_child(left_projectile)

    projectile_instance = phase_1_projectile.instantiate()
    var right_projectile = projectile_instance.duplicate()
    right_projectile.global_position = right_barrel.global_position
    get_tree().current_scene.add_child(right_projectile)


func _on_phase_2_projectile_reload_timeout() -> void:
    print("shoot")
    var num_projectiles = 16
    var angle_step = 2 * PI / num_projectiles

    for i in range(num_projectiles):
        var projectile = phase_2_projectile.instantiate()
        get_tree().current_scene.add_child(projectile)
        projectile.global_position = phase_2_node.global_position
        var angle = i * angle_step
        var direction = Vector2(cos(angle), sin(angle))

        projectile.launch(direction)
