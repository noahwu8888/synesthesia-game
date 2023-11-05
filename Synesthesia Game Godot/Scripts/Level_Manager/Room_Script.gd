extends Node

@export var current_room = 0

@export var transition_timer = 0.0
@export var left_bound = 0
@export var right_bound = 0
@export var upper_bound = 0
@export var lower_bound = 0
@export var default_y = 0
@export var zoom = Vector2()
@export var vertical_pan_trigger = 0
@export var vertical_pan_reset_trigger = 0
@export var vertical_pan_distance = 0
@export var max_stationary_distance = 0
@export var stop_distance = 0 
@export var catch_up_speed = 0.0 
@export var max_change_in_speed = 0.0
@export var look_ahead = 0
@export var vertical_pan_speed = 0.0


var root_node

func _ready():
	root_node = get_tree().root.get_child(0)
