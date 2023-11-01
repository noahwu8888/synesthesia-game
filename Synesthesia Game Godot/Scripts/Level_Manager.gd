extends Node

@onready var room_holder = $Rooms
var rooms
@onready var camera = $Camera
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	rooms = room_holder.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		move_to_room(1)
	print(camera.position.x)
func move_to_room(room_number):
	var room = self.rooms[room_number]
	self.camera.new_export_vars(0, room.left_bound, room.right_bound)
