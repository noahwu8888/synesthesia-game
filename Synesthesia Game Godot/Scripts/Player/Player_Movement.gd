extends CharacterBody2D

#speed control
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

#animation control
@export var ANIM_IDLE_SPEED = 1.0
@export var ANIM_RUN_SPEED = 2.0
@export var ANIM_JUMP_SPEED = 2.0
@export var ANIM_FALL_SPEED = 2.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_loaded(player) # Necessary for Camera to track player
var facing_right = true # Also necessary for camera controls

@onready var anim = get_node("AnimationPlayer")

func _ready():
	self.player_loaded.emit(self) # Again necessary for camera to track player
	anim.speed_scale = ANIM_IDLE_SPEED

func moo():
	pass
	

func _physics_process(delta):
	#self.Sprite
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		anim.speed_scale = ANIM_JUMP_SPEED
		anim.play("Jump")
		velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if velocity.y < 0:
			anim.speed_scale = ANIM_JUMP_SPEED
			anim.play("Jump")
		else:
			anim.speed_scale = ANIM_FALL_SPEED
			anim.play("Fall")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_vector("negative_x", "positive_x", "negative_y", "positive_y", )
	var xDir = direction.x
	
	if direction.x != 0: # Calculates whether most recently moved right or left
		self.facing_right = bool((direction.x + 1) / 2) 
	
	if (abs(xDir) > 0.1):
		get_node("Sprite2D").flip_h = (sign(xDir) == -1)
		
		velocity.x = xDir * SPEED
		if is_on_floor():
			anim.speed_scale = ANIM_RUN_SPEED
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x == 0 and is_on_floor():
			anim.speed_scale = ANIM_IDLE_SPEED
			anim.play("Idle")
	
	move_and_slide()
	

func _on_player_loaded(player):
	pass # Replace with function body.
