extends Node2D

@onready var parent : Node = get_parent()
#animation control
@export var ANIM_IDLE_SPEED = 1.0
@export var ANIM_RUN_SPEED = 2.0
@export var ANIM_JUMP_SPEED = 2.0
@export var ANIM_FALL_SPEED = .5
var isFacingRight: bool = true

var velocity
var grounded

@onready var animation_player = get_node("AnimationPlayer")
@onready var sprite_2d = get_node("Sprite2D")
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	print(parent)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_parent_vars()
	if Input.is_action_pressed("negative_x"):
		isFacingRight = false
	
	if Input.is_action_pressed("positive_x"):
		isFacingRight = true
	
	sprite_2d.set_flip_h(!isFacingRight)
	
	if not grounded:
		if velocity.y < 0:
			animation_player.speed_scale = ANIM_JUMP_SPEED
			animation_player.play("Jump")
		else:
			animation_player.speed_scale = ANIM_FALL_SPEED
			animation_player.play("Fall")
	else:
		if abs(velocity.x) > 0.1 and grounded:
			animation_player.speed_scale = ANIM_RUN_SPEED
			animation_player.play("Run")
		else:
			animation_player.speed_scale = ANIM_IDLE_SPEED
			animation_player.play("Idle")

func update_parent_vars():
	velocity = parent.velocity
	grounded = parent.is_on_floor()
	
