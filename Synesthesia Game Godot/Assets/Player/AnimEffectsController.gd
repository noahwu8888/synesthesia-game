extends CharacterBody2D

#animation control
@export var ANIM_IDLE_SPEED = 1.0
@export var ANIM_RUN_SPEED = 2.0
@export var ANIM_JUMP_SPEED = 2.0
@export var ANIM_FALL_SPEED = 2.0
var isFacingRight: bool = true


@onready var animation_player = get_node("AnimationPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("moveLeft"):
		isFacingRight = false
	
	if Input.is_action_pressed("moveRight"):
		isFacingRight = true
	
	#Flips sprite with direction
	animation_player.set_flip_h(!isFacingRight)
	
	if abs(velocity.x) > 0.1 and is_on_floor():
		animation_player.play("walkAnim")
	else:
		animation_player.play("idleAnim")
