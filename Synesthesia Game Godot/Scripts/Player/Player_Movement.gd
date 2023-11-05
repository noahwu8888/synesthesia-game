extends CharacterBody2D

#animation control
@export var ANIM_IDLE_SPEED = 1.0
@export var ANIM_RUN_SPEED = 2.0
@export var ANIM_JUMP_SPEED = 2.0
@export var ANIM_FALL_SPEED = 2.0

#character physics control
@export var SPEED = 300.0

@export var COYOTE_TIME = 0.5
@export var ANTICIPATE_LANDING_JUMP_HOLD_TIME = 1 #how long you can be holding the jump input while not grounded before that held jump gets rejected
@export var ANTICIPATE_JUMP_CARRYOVER_TIME = 0.2 #if you release a jump right before landing on ground, if it's within this time, the jump will be carried over and trigger upon landing

@export var TAP_JUMP_THRESH = 0.03 #special behavior if jump held time is within this? think one frame jumps - potentially when you do a one frame jump upon landing, it does a high power jump or something?
@export var MAX_JUMP_HOLD_TIME = 0.5
@export var CROUCHING_TIME_TILL_SLOWDOWN = 0.2
@export var CROUCHING_SLOWDOWN_TIME = 0.3

@export var JUMP_POWER = 200.0
@export var MAX_JUMP_MODIFIER = 0.2


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_loaded(player) # Necessary for Camera to track player
var facing_right = true # Also necessary for camera controls

#character states
var holdingJump = false
var heldJumpTime = 0
var rejectHeldJumpTime = 0
var jumpRejected = false

var carryOverJump = false
var carryOverTime = 0

var isCoyote = false
var lastTouchingGround = 0

@onready var anim = get_node("AnimationPlayer")

func _ready():
	self.player_loaded.emit(self) # Again necessary for camera to track player
	anim.speed_scale = ANIM_IDLE_SPEED

func easingOutQuad(x):
	return 1 - (1 - x) * (1 - x)
	
func jump(isCarryOver):
	if isCoyote or isCarryOver:
		var calculatedJumpPower
		if false: #heldJumpTime < TAP_JUMP_THRESH: #tap jump
			calculatedJumpPower = JUMP_POWER * (1 + MAX_JUMP_MODIFIER)
		else:
			var adjustedTime = heldJumpTime - TAP_JUMP_THRESH
			var heldPercent = easingOutQuad(min(adjustedTime, MAX_JUMP_HOLD_TIME) / MAX_JUMP_HOLD_TIME)
			calculatedJumpPower = JUMP_POWER * (1 + heldPercent * MAX_JUMP_MODIFIER)
			
		velocity.y = -1.0 * calculatedJumpPower
		anim.speed_scale = ANIM_JUMP_SPEED
		anim.play("Jump")
	else:
		carryOverJump = true
		carryOverTime = 0

func calc_jump_states(delta):
	if holdingJump:
		heldJumpTime += delta
		
		if isCoyote:
			if rejectHeldJumpTime > ANTICIPATE_LANDING_JUMP_HOLD_TIME:
				jumpRejected = true
			rejectHeldJumpTime = 0
		else:
			rejectHeldJumpTime += delta 
	
	if Input.is_action_pressed("jump"):
		if not holdingJump:
			rejectHeldJumpTime = 0
			heldJumpTime = 0
			jumpRejected = false
		holdingJump = true
		carryOverJump = false
	else:
		if holdingJump and (not jumpRejected):
			jump(false)
		holdingJump = false


func _physics_process(delta):
	if is_on_floor():
		isCoyote = true
		lastTouchingGround = 0
	else:
		lastTouchingGround += delta
		if lastTouchingGround > COYOTE_TIME:
			isCoyote = false
	
	if carryOverJump:
		carryOverTime += delta
		if isCoyote:
			if carryOverTime < ANTICIPATE_JUMP_CARRYOVER_TIME:
				jump(true)
			carryOverJump = false
	
	calc_jump_states(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y < 0:
			anim.speed_scale = ANIM_JUMP_SPEED
			anim.play("Jump")
		else:
			anim.speed_scale = ANIM_FALL_SPEED
			anim.play("Fall")
	
	var direction = Input.get_vector("negative_x", "positive_x", "negative_y", "positive_y", )
	var xDir = direction.x
	
	if direction.x != 0: # Calculates whether most recently moved right or left
		self.facing_right = bool((direction.x + 1) / 2) 
	
	if (abs(xDir) > 0.1):
		get_node("Sprite2D").flip_h = (sign(xDir) == -1)
		
		var slowdownAmount = clamp((heldJumpTime - CROUCHING_TIME_TILL_SLOWDOWN) / CROUCHING_SLOWDOWN_TIME, 0, 1)
		var crouchingMovementMod = (1 - 0.5 * slowdownAmount) if (is_on_floor() and holdingJump and (not jumpRejected)) else 1
		velocity.x = xDir * crouchingMovementMod * SPEED
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
