extends Node

@onready var room_holder = $Rooms
var rooms
@onready var camera = $Camera
@onready var player = $Player
static var current_room = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rooms = room_holder.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func move_to_room(room_number):
	var room = self.rooms[room_number]
	self.camera.new_export_vars(0, room.left_bound, room.right_bound)
	current_room = room_number
