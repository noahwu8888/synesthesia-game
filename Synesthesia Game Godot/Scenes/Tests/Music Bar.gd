extends Area2D


@export var direction : Vector2
@export var beatsPerMinute = 0
@export var beatsPerMeasure = 0
@export var measuresPerLoop = 0

var move_speed : float = ((60 / beatsPerMinute) * beatsPerMeasure * (measuresPerLoop))
var start_pos : Vector2
var target_pos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = global_position
	target_pos = start_pos + direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(target_pos, move_speed * delta)

	if global_position == target_pos:
		if global_position == start_pos:
			target_pos = start_pos + direction
		else:
			target_pos = start_pos 
