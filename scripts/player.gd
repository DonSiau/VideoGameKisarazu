extends CharacterBody2D

@onready var projectile_barrel_Right = $projectile_barrel_Right
@onready var projectile_barrel_Left = $projectile_barrel_Left
@onready var animated_sprite = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var sword = $sword
@onready var Projectile = preload("res://scenes/playerProjectile.tscn")
@onready var ProjectileSpecialBomb = preload("res://scenes/playerProjectileBomb.tscn")
@onready var weapon_select_instance = $"../CanvasLayer/WeaponSelect"
@onready var world = get_tree().current_scene

const SPEED = 170.0
const DASH_SPEED = 350
const JUMP_VELOCITY = -270.0
const wall_jump_pushback = 350
const wallslide_friction = -800.0

# State flags
var is_dead = false
var is_wall_sliding = false
var is_dashing = false
var is_swording = false
var is_running = false
var is_falling = false
var is_hurt = false
var is_jumping = false
var wall_jump_buffer = 0.0
const WALL_JUMP_BUFFER_TIME = 0.2

# Player stats
var health = 5
var projectileSelected = Projectile
var ammo = 6

func set_healthBar() -> void:
    $CanvasLayer/HealthBar.value = max(health, 0)

func _ready():
    add_to_group("Player")
    set_healthBar()
    projectileSelected = Projectile

func gain_health(amount: int):
    health += amount
    set_healthBar()

func take_damage(amount: int):
    health -= amount
    set_healthBar()
    if health <= 0:
        die()
    else:
        is_hurt = true
        await animated_sprite.animation_finished
        is_hurt = false

func die():
    if not is_dead:
        is_dead = true
        update_animation()

func update_animation():
    if is_dead:
        animated_sprite.play("death")
        return
    if is_hurt:
        animated_sprite.play("hurt")
    elif is_swording and is_running:
        animated_sprite.play("run_sword")
        await animated_sprite.animation_finished
        sword.end_attack()
        is_swording = false
    elif is_swording:
        animated_sprite.play("idle_sword")
        await animated_sprite.animation_finished
        sword.end_attack()
        is_swording = false
    elif is_dashing:
        animated_sprite.play("dash")
    elif is_wall_sliding:
        animated_sprite.play("wall_slide")
    elif is_falling:
        animated_sprite.play("fall")
    elif is_running:
        animated_sprite.play("run")
    else:
        animated_sprite.play("idle")

func jump():
    if is_on_floor():
        velocity.y = JUMP_VELOCITY
        is_jumping = true
    elif is_wall_sliding and Input.is_action_just_pressed("ui_select"):
        wall_jump()

func wall_jump():
    wall_jump_buffer = WALL_JUMP_BUFFER_TIME
    velocity.y = JUMP_VELOCITY * 0.8
    if sprite.flip_h:
        velocity.x = wall_jump_pushback
    else:
        velocity.x = -wall_jump_pushback
    is_wall_sliding = false
    is_jumping = true

func handle_wall_slide(delta):
    if wall_jump_buffer > 0:
        wall_jump_buffer -= delta
        return

    is_wall_sliding = false
    if is_on_wall() and !is_on_floor():
        if Input.is_action_pressed("a") or Input.is_action_pressed("d"):
            if !is_hurt and wall_jump_buffer <= 0:
                is_wall_sliding = true

    if is_wall_sliding and velocity.y > 0:
        velocity.y += (wallslide_friction * delta)
        velocity.y = min(velocity.y, get_gravity().y)

func handle_shoot():
    var projectile
    if Input.is_action_just_pressed("q") and !is_swording and !is_hurt and !is_wall_sliding:
        projectile = projectileSelected.instantiate()
    if projectile:
        get_tree().current_scene.add_child(projectile)
        var direction: Vector2
        var active_barrel: Node2D
        if sprite.flip_h:
            direction = Vector2.LEFT
            active_barrel = projectile_barrel_Left
        else:
            direction = Vector2.RIGHT
            active_barrel = projectile_barrel_Right
        projectile.global_position = active_barrel.global_position
        projectile.launch(direction)

func handle_sword():
    if Input.is_action_just_pressed("e") and !is_swording and !is_hurt:
        is_swording = true
        if sprite.flip_h:
            sword.rotation_degrees = 180
        else:
            sword.rotation_degrees = 0
        sword.start_attack()
        await get_tree().create_timer(0.2).timeout
        sword.end_attack()
        is_swording = false

func _physics_process(delta: float) -> void:
    if is_dead:
        return
    is_running = false
    is_falling = false
    if not is_on_floor():
        velocity += get_gravity() * delta
        is_falling = true
    if Input.is_action_just_pressed("ui_select"):
        jump()
    if Input.is_action_just_pressed("alt"):
        is_dashing = true
        $dash_timer.start()
    var direction := Input.get_axis("a", "d")
    if direction != 0:
        if is_dashing:
            velocity.x = direction * DASH_SPEED
        else:
            velocity.x = direction * SPEED
            if is_on_floor():
                is_running = true
        if !is_wall_sliding:
            sprite.flip_h = (direction < 0)
    else:
        if wall_jump_buffer <= 0:
            velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    handle_wall_slide(delta)
    handle_shoot()
    handle_sword()
    update_animation()

func _on_dash_timer_timeout() -> void:
    is_dashing = false
