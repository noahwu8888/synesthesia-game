extends CollisionShape2D


@export var move_seppd : float = 30.0
@export var direction : Vector2

var start_pos : Vector2
var target_pos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	
	start_pos = global_position
	target_pos = start_pos + direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(target_pos, move_seppd*delta)

	if global_position == target_pos:
		target_pos = start_pos + direction
	else:
		target_pos = start_pos
