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
@onready var currentWeapon="projectile"
@onready var dash_timer: Timer = $dash_timer
@onready var dash_reload: Timer = $dash_reload
@onready var coyote_time: Timer = $coyoteTime

#audio
@onready var audio_stream_player_jump: AudioStreamPlayer2D = $AudioStreamPlayer_Jump
@onready var audio_stream_player_2d_hurt: AudioStreamPlayer2D = $AudioStreamPlayer2D_hurt
@onready var audio_stream_player_2d_die: AudioStreamPlayer2D = $AudioStreamPlayer2D_die

const GRAVITY=100
const FALL_GRAVITY=150
const SPEED = 145.0
const DASH_SPEED = 350
const JUMP_VELOCITY = -300
const wall_jump_pushback = 350
const wallslide_friction = -1200

# State flags
var is_depowered=false #for level 4. if depowered, player cannot attack or shoot
var isCoyote=false
var dash_direction = 0
var is_dead = false
var dashable=true
var is_wall_sliding = false
var is_dashing = false
var is_swording = false
var is_running = false
var is_falling = false
var is_hurt = false
var is_jumping = false
var can_jump = true
var is_jump_pressed = false
var is_sneaking=false
var wall_jump_buffer = 0.0
const WALL_JUMP_BUFFER_TIME = 0.2

# Player stats
var last_checkpoint=Vector2.ZERO
var health = 5
var projectileSelected = Projectile
var ammo = 10
func set_healthBarInvisible()-> void:
    $CanvasLayerHealth.visible=false;
func set_healthBarVisible()-> void:
    $CanvasLayerHealth.visible=true;
func set_healthBar() -> void:
    $CanvasLayerHealth/HealthBar.value = max(health, 0)

func set_ammoBarInvisible()-> void:
    $CanvasLayerAmmo.visible=false;
func set_ammoBarVisible()-> void:
    $CanvasLayerAmmo.visible=true;
func set_ammoBar() -> void:
    $CanvasLayerAmmo/AmmoBar.value = max(ammo, 0)

func _ready():
    add_to_group("Player")
    set_healthBar()
    set_ammoBar()
    #comment out below to change spawn position
    #global_position=LevelState.current_checkpoint
    projectileSelected = Projectile

func decreaseAmmo(amount: int):
    ammo -= amount
    set_ammoBar()
func gain_health(amount: int):
    health += amount
    set_healthBar()

func take_damage(amount: int):
   if not is_sneaking and not is_dead:
    health -= amount
    set_healthBar()
    audio_stream_player_2d_hurt.play()
    if health <= 0:
        die()
    else:
        is_hurt = true
        await animated_sprite.animation_finished
        is_hurt = false

func die():
    if not is_dead:
        is_dead = true
        audio_stream_player_2d_die.play()
        update_animation()
        await animated_sprite.animation_finished

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
    if (is_on_floor() or $RayCast2D.is_colliding()) and (can_jump) or (isCoyote):
        velocity.y = JUMP_VELOCITY
        audio_stream_player_jump.play()
        is_jumping = true
        can_jump = false
        is_jump_pressed = true
    elif is_wall_sliding and Input.is_action_just_pressed("ui_select"):
        wall_jump()

func wall_jump():
    wall_jump_buffer = WALL_JUMP_BUFFER_TIME
    velocity.y = JUMP_VELOCITY * 0.85
    audio_stream_player_jump.play()
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
 if not is_depowered:
    var projectile
    if Input.is_action_just_pressed("q") and !is_swording and !is_hurt and !is_wall_sliding:
     projectile = projectileSelected.instantiate()
     if currentWeapon=="projectile" or ammo >0:
      if projectile:
          if currentWeapon=="bombProjectile" or currentWeapon=="areaBlastProjectile":
           decreaseAmmo(1)
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
  if not is_depowered:
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
    print(is_sneaking)
    if is_dead:
        return
    is_running = false
    is_falling = false

    if is_on_floor():
        can_jump = true

    if not is_on_floor():
        if is_jumping==false and not is_wall_sliding:
         isCoyote=true
         coyote_time.start()

        if velocity.y<0:
             velocity += get_gravity() * delta
        else:
            velocity += get_gravity()*1.5*delta
        if !$RayCast2D.is_colliding():
            is_falling = true

    if Input.is_action_just_released("ui_select") and velocity.y < 0 and is_jump_pressed:
        velocity.y = JUMP_VELOCITY / 4
        is_jump_pressed = false

    if Input.is_action_just_pressed("ui_select"):
        jump()

    var direction := Input.get_axis("a", "d")
    if (Input.is_action_just_pressed("alt")) and (dashable==true):
        is_dashing = true
        dashable=false
        dash_reload.start()

        if direction != 0:
            dash_direction = direction
        else:
            if sprite.flip_h:
                dash_direction = -1
            else:
                dash_direction = 1
        dash_timer.start()
    if is_dashing:
        velocity.x = dash_direction * DASH_SPEED
    elif direction != 0:
        velocity.x = direction * SPEED
        if is_on_floor() or $RayCast2D.is_colliding():
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


func _on_dash_reload_timeout() -> void:
    dashable=true
    print("yeah")


func _on_coyote_time_timeout() -> void:
    isCoyote=false
