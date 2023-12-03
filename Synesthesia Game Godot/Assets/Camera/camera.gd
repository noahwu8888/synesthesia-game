extends Camera2D

# ASSUMES THAT CAMERA IS SIBLING TO CHARACTER AND WILL NOT WORK IF CAMERA DOES NOT DETECT PLAYER

@onready var transition_timer = $Transition_Timer

## What x value is the minimum x value the camera can go
@export var left_bound = 0
## What x value is the maximum x value the camera can go
@export var right_bound = 1500
## Maximum horizontal distance player can be from center of the camera before camera will pan
@export var max_stationary_distance = 100
## How close the camera has to be to the target location to stop panning
@export var stop_distance = 10
## How quickly the camera will catch up to the player, 0 won't move camera, 1 will snap camera to player position
@export var catch_up_speed = 1.2
## Maximum change in speed
@export var max_change_in_speed = 0.3
## How much forward the camera should go in front of the player
@export var look_ahead = 300
## Default y height the camera will be hugging
@export var default_y = 0
## How far from the default_y the player has to be to trigger a pan
@export var vertical_pan_trigger = 200
## How far the player has to be from the default_y in order to reset the verticality of the camera
@export var vertical_pan_reset_trigger = 175
## How far the camera should vertically pan when the player reaches the threshold
@export var vertical_pan_distance = 100
## Speed camera goes up/down when the player reaches the desired threshold
@export var vertical_pan_speed = 1.2

const WINDOW_WIDTH = 1152

var moving = false # tracks if the camera is moving

var player # Gets populated by player when player loads in 

var transition_time
var new_zoom
var transition = false
var old_speed = 0

var start_at_end = false

var vertical_transition_distance = null
var horizonatal_transition_distance = null
var zoom_transition_distance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.y = self.default_y
	var bound_modifier = self.WINDOW_WIDTH / (2 * self.zoom.x)
	self.left_bound += bound_modifier
	self.right_bound -= bound_modifier



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(self.start_at_end)
	if transition:
		if self.vertical_transition_distance == null:
			self.vertical_transition_distance = self.default_y - self.global_position.y
			self.horizonatal_transition_distance = (self.right_bound if self.start_at_end else self.left_bound) - self.global_position.x
			self.zoom_transition_distance = self.new_zoom - self.zoom
		self.global_position.x += (self.horizonatal_transition_distance * delta) / self.transition_time
		self.global_position.y += (self.vertical_transition_distance * delta) / self.transition_time
		self.zoom += (Vector2(self.zoom_transition_distance.x, self.zoom_transition_distance.y) * delta) / transition_time
		
	elif self.player: # Doesn't try to do anything if doesn't know where player is
		var player_distance = player.position.x - self.position.x + self.look_ahead # Tracks how far camera is from target location
		
		if abs(player_distance) > max_stationary_distance:
			self.moving = true
		
		if self.moving: # Used to figure out where the camera should be going
			var right_wall_distance = self.right_bound - self.global_position.x
			var left_wall_distance = self.left_bound - self.global_position.x
			
			var movement_distance = player_distance
			if self.player.facing_right and abs(movement_distance) > abs(right_wall_distance): movement_distance = right_wall_distance
			if not self.player.facing_right and abs(movement_distance) > abs(left_wall_distance): movement_distance = left_wall_distance
			
			# Used to clamp the maximum change in speed, stops jittery camera bug when close to walls
			var change_in_pos = min(abs(movement_distance) * self.catch_up_speed * delta, old_speed + self.max_change_in_speed) 
			
			self.global_position.x += change_in_pos * (1 if movement_distance >= 0 else -1)
			
			self.old_speed = change_in_pos + self.max_change_in_speed
			
			if self.stop_distance > abs(player_distance): moving = false
		if self.global_position.x > self.right_bound: self.global_position.x = self.right_bound # fix if goes too far right
		if self.global_position.x < self.left_bound: self.global_position.x = self.left_bound # Fix if goes too far left
		
		if abs(self.player.global_position.y - self.default_y) > self.vertical_pan_trigger:
			# Could probably be cleaned up more like one line elif, tbh writing it when very tired  
			var up = self.player.global_position.y - self.default_y < self.vertical_pan_trigger # whether panning up or not
			var desired_pan = self.default_y + (self.vertical_pan_distance * (-1 if up else 1)) - self.global_position.y
			self.global_position.y += (desired_pan * self.vertical_pan_speed * delta)
		elif abs(self.player.global_position.y - self.default_y) < self.vertical_pan_reset_trigger:
			self.global_position.y += (self.default_y - self.global_position.y) * self.vertical_pan_speed * delta


func _on_player_player_loaded(player):
	self.player = player
	
# Isn't this method an absolute bundle of joy
# Each parameter corresponds to the exports above, and do the same
# Every parameter by default is unchanged
func new_export_vars(
					transition_time, #Only required args, in seconds, 0 means snap cut!!!
					start_at_end: bool = false, # whether it statts at left bound or right bound
					left_bound: int = self.left_bound,
					right_bound: int = self.right_bound, 
					default_y: int = self.default_y,
					zoom: Vector2 = self.zoom,
					vertical_pan_trigger: int = self.vertical_pan_trigger, 
					vertical_pan_reset_trigger: int = self.vertical_pan_reset_trigger,
					vertical_pan_distance: int = self.vertical_pan_distance,
					max_stationary_distance: int = self.max_stationary_distance, 
					stop_distance: int = self.stop_distance, 
					catch_up_speed: float = self.catch_up_speed, 
					max_change_in_speed: float = self.max_change_in_speed,
					look_ahead: int = self.look_ahead,
					vertical_pan_speed: float = self.vertical_pan_speed,
					):
	if self.transition:
		return
	var bound_modifier = self.WINDOW_WIDTH / (2 * zoom.x)
	self.start_at_end = start_at_end
	
	self.transition_time = transition_time
	self.left_bound = left_bound + bound_modifier
	self.right_bound = right_bound - bound_modifier
	self.max_stationary_distance = max_stationary_distance
	self.stop_distance = stop_distance
	self.catch_up_speed  = catch_up_speed
	self.max_change_in_speed  = max_change_in_speed
	self.look_ahead = look_ahead
	self.default_y = default_y
	self.vertical_pan_trigger = vertical_pan_trigger
	self.vertical_pan_reset_trigger = vertical_pan_reset_trigger
	self.vertical_pan_distance = vertical_pan_distance
	self.vertical_pan_speed = vertical_pan_speed
	self.new_zoom = zoom
	if self.transition_time != 0: # snap cut for if time is 0 to avoid infinet values 
		self.transition = true;
		self.transition_timer.start(self.transition_time)
	else:
		self.global_position.x = self.left_bound
		self.zoom = self.new_zoom
		self.global_position.y = self.default_y

func _on_transition_timer_timeout():
	self.transition = false
	self.vertical_transition_distance = null
	self.horizonatal_transition_distance = null
	self.zoom_transition_distance = null
	self.zoom = self.new_zoom
