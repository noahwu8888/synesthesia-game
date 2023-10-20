extends CharacterBody2D

#animation control
@export var ANIM_IDLE_SPEED = 1.0
@export var ANIM_RUN_SPEED = 2.0
@export var ANIM_JUMP_SPEED = 2.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

func _ready():
	anim.speed_scale = ANIM_IDLE_SPEED

func _process(delta):
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
	if direction and not is_on_floor():
		anim.speed_scale = ANIM_RUN_SPEED
		anim.play("Run")
	else:
		if velocity.x == 0:
			anim.speed_scale = ANIM_IDLE_SPEED
			anim.play("Idle")
	
