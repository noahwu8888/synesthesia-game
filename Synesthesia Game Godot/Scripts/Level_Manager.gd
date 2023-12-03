extends Node

#start room holder
@onready var room_holder = $Rooms
var rooms
@onready var camera = $Camera
@onready var player = $Player

static var current_room = 0

var should_transition = false
var transition_timer = 0.0

#current room
var room
var music_bar
var output_pos
var room_number
#dictates what type of transition to do
var type_of_transition
# Called when the node enters the scene tree for the first time.
func _ready():
	rooms = room_holder.get_children()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_transition && music_bar.reached_end:
		transition_zoom(room_number, output_pos)
		print(current_room)

func move_to_room(room_number, output_pos):
	room = self.rooms[room_number]
	music_bar = self.rooms[current_room].get_child(0, false)
	self.output_pos = output_pos
	self.room_number = room_number
	print(music_bar.reached_end)
	"""
	Insert Player Freeze Code Here
	"""
	should_transition = true
	
	#print(current_room)


#for zoom transitions
func transition_zoom(room_number, output_pos):
	self.camera.new_export_vars(room.transition_timer, room.left_bound, room.right_bound, room.default_y, room.zoom)
	player.global_position = output_pos
	current_room = room_number
	should_transition = false

#for all variables modified
func transition_adv(room_number, output_pos):
	self.camera.new_export_vars(room.transition_timer, room.left_bound, room.right_bound, room.default_y, room.zoom, room.vertical_pan_trigger, room.vertical_pan_reset_trigger, room.vertical_pan_distance)
	player.global_position = output_pos
	current_room = room_number
	should_transition = false
