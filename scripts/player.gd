extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var sword = $sword
var bullet = preload("res://scenes/projectile.tscn")  # Adjust path to match your project structure
const SPEED = 200.0
const DASH_SPEED = 400
const JUMP_VELOCITY = -250.0
const wall_jump_pushback = 350  # Increased for more pronounced wall jump
const wallslide_friction = -800.0

# State flags
var is_dead = false
var is_wall_sliding = false
var is_dashing = false
var is_swording=false
var is_running = false
var is_falling = false
var is_hurt = false
var is_jumping = false
var wall_jump_buffer = 0.0  # Time before wall sliding can resume after wall jump
const WALL_JUMP_BUFFER_TIME = 0.2  # Seconds to wait before allowing wall slide again

# Health system
var health = 5

func take_damage(amount: int):
    health -= amount
    print(health)

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
    # Return early if dead - death animation takes precedence
    if is_dead:
        animated_sprite.play("death")
        return
     # Animation priority order
    if is_hurt:
        animated_sprite.play("hurt")
    elif is_swording and is_running:
        animated_sprite.play("run_sword")
        await animated_sprite.animation_finished
        sword.end_attack()  # Call to end attack after animation
        is_swording = false  # Reset swording after animation plays
    elif is_swording:
        animated_sprite.play("idle_sword")
        await animated_sprite.animation_finished
        sword.end_attack()
        is_swording = false  # Reset swording after animation plays
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
    wall_jump_buffer = WALL_JUMP_BUFFER_TIME  # Set buffer time
    velocity.y = JUMP_VELOCITY * 0.8  # Slightly reduced vertical jump for wall jumps

    # Determine wall jump direction based on which direction player is facing
    if animated_sprite.flip_h:  # If facing left
        velocity.x = wall_jump_pushback  # Jump right
    else:
        velocity.x = -wall_jump_pushback  # Jump left

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
func handle_sword():
    if Input.is_action_just_pressed("e") and !is_swording:
        is_swording = true
        sword.start_attack()  # Enable attack area collision

func _physics_process(delta: float) -> void:
    if is_dead:
        return

    # Reset state flags
    is_running = false
    is_falling = false

    # Apply gravity
    if not is_on_floor():
        velocity += get_gravity() * delta
        is_falling = true

    # Handle jump
    if Input.is_action_just_pressed("ui_select"):
        jump()

    # Handle dash
    if Input.is_action_just_pressed("w"):
        is_dashing = true
        $dash_timer.start()

    # Handle movement
    var direction := Input.get_axis("a", "d")
    if direction != 0:
        if is_dashing:
            velocity.x = direction * DASH_SPEED
        else:
            velocity.x = direction * SPEED
            if is_on_floor():
                is_running = true

        # Only flip sprite if not wall sliding
        if !is_wall_sliding:
            animated_sprite.flip_h = direction < 0
    else:
        # Don't reset horizontal velocity during wall jump
        if wall_jump_buffer <= 0:
            velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
    handle_wall_slide(delta)
    handle_sword()
    update_animation()

func _on_dash_timer_timeout() -> void:
    is_dashing = false
