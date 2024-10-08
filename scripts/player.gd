extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 200.0
const DASH = 450
const JUMP_VELOCITY = -250.0
const wall_jump_pushback=30
var is_wall_sliding=false
const wallslide_friction=-1000.0


# Animation States
enum AnimState {IDLE, RUN, HURT, DEATH, FALL, WALL_SLIDE}
var current_state = AnimState.IDLE

#health system
var health = 5
func take_damage(amount: int):
    health -= amount  # Reduce health by the damage amount
    print(health)

    if health <= 0:  # Check if health is zero or less
        die()
    else:
        print("Playing hurt animation")  # Debugging line
        change_state(AnimState.HURT)  # Change to hurt state
        await animated_sprite.animation_finished
        change_state(AnimState.IDLE)  # Return to idle after hurt finishes

var is_dead = false  # Flag to track if the player is dead
# Function called when the player dies
func die():
    if not is_dead:  # Prevent multiple calls to die
        is_dead = true  # Set dead flag
        change_state(AnimState.DEATH)

func change_state(new_state: AnimState):
    if current_state == AnimState.DEATH:  # Don't change state if dead
        return

    match new_state:
        AnimState.IDLE:
            animated_sprite.play("idle")
        AnimState.RUN:
            animated_sprite.play("run")
        AnimState.HURT:
            animated_sprite.play("hurt")
        AnimState.DEATH:
            animated_sprite.play("death")
        AnimState.FALL:
            animated_sprite.play("fall")
        AnimState.WALL_SLIDE:
            animated_sprite.play("wall_slide")

    current_state = new_state
func jump():
    if is_on_floor():
        velocity.y = JUMP_VELOCITY
    elif is_wall_sliding and Input.is_action_just_pressed("ui_select"):  # Can jump while wall sliding
        if Input.is_action_pressed("ui_right"):
            velocity.y = JUMP_VELOCITY
            velocity.x = -wall_jump_pushback
        elif Input.is_action_pressed("ui_left"):
            velocity.y = JUMP_VELOCITY
            velocity.x = wall_jump_pushback

func wall_slide(delta):
    if is_on_wall() and !is_on_floor():
        if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
         if current_state != AnimState.HURT:
          is_wall_sliding = true
        else:
            is_wall_sliding = false
    else:
        is_wall_sliding = false

    if is_wall_sliding and velocity.y > 0:  # Only play wall slide when moving downward
        change_state(AnimState.WALL_SLIDE)
        velocity.y += (wallslide_friction * delta)
        velocity.y = min(velocity.y, get_gravity().y)


# Called every physics frame
func _physics_process(delta: float) -> void:
    if is_dead:
        return

    # Add gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta
        # Play fall animation when moving downward
        if current_state != AnimState.HURT:  # Check if falling
            change_state(AnimState.FALL)

    # Handle jump.
    if Input.is_action_pressed("ui_select"):
        jump()


    # Get input direction for movement
    var direction := Input.get_axis("ui_left", "ui_right")
    if direction:
        velocity.x = direction * SPEED
        if current_state != AnimState.HURT and is_on_floor():  # Only change state if not hurt and on floor
            change_state(AnimState.RUN)
        animated_sprite.flip_h = direction < 0  # Flip sprite when moving left
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        if current_state != AnimState.HURT and is_on_floor():  # Only change state if not hurt and on floor
            change_state(AnimState.IDLE)
    move_and_slide()  # Move the player
    wall_slide(delta)
