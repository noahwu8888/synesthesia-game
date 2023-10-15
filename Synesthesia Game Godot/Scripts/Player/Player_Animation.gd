extends CharacterBody2D

#speed control
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

#animation control
@export var ANIM_IDLE_SPEED = 1.0
@export var ANIM_RUN_SPEED = 2.0
@export var ANIM_JUMP_SPEED = 2.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

func _ready():
	anim.speed_scale = ANIM_IDLE_SPEED

func _physics_process(delta):
	#self.Sprite
	
	var collision = $WallArea/CollisionShape2D
	
	move_and_slide()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		anim.speed_scale = ANIM_JUMP_SPEED
		anim.play("Jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		anim.speed_scale = ANIM_RUN_SPEED
		anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x == 0:
			anim.speed_scale = ANIM_IDLE_SPEED
			anim.play("Idle")
	
	
	move_and_slide()
	var moo = $WallArea
	moo.get_overlapping_bodies()
	


func _on_wall_area_body_entered(body):
	pass # Replace with function body.
