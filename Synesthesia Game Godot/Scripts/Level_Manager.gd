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
	

func move_to_room(room_number, output_pos):
	var room = self.rooms[room_number]
	self.camera.new_export_vars(room.transition_timer, room.left_bound, room.right_bound, room.default_y)
	player.global_position = output_pos
	current_room = room_number

func move_to_room_zoom(room_number, output_pos):
	var room = self.rooms[room_number]
	self.camera.new_export_vars(room.transition_timer, room.left_bound, room.right_bound, room.default_y, room.zoom)
	player.global_position = output_pos
	current_room = room_number

func move_to_room_adv(room_number, output_pos):
	var room = self.rooms[room_number]
	self.camera.new_export_vars(room.transition_timer, room.left_bound, room.right_bound, room.default_y, room.zoom, room.vertical_pan_trigger, room.vertical_pan_reset_trigger, room.vertical_pan_distance)
	player.global_position = output_pos
	current_room = room_number
