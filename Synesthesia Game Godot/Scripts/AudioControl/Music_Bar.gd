extends Area2D

@export var start_pos : Vector2
@export var end_pos : Vector2

@export var direction : Vector2
@export var move_speed : float = 30.0
@export var beatsPerMinute = 0
@export var beatsPerMeasure = 0
@export var measuresPerLoop = 0

var elapsedTime = 0
var percentToEnd = 0
var reached_end = false
#var move_speed : float = ((60 / beatsPerMinute) * beatsPerMeasure * (measuresPerLoop))

# Called when the node enters the scene tree for the first time.
func _ready():
	
	move_speed = ((60.0 / beatsPerMinute) * beatsPerMeasure * (measuresPerLoop))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsedTime += delta;
	
	percentToEnd = min(elapsedTime / move_speed, 1.00)
	position = start_pos.lerp(end_pos, percentToEnd);
	
	if percentToEnd > .01:
		reached_end = false
	
	if position.x == end_pos.x:
		position = start_pos
		elapsedTime = 0
		reached_end = true
		
		
		#if global_position == start_pos:
			#target_pos = start_pos + direction
		#else:
			#target_pos = start_pos 
