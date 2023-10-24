extends Node

#platform drop control
@export var drop_amount = 5.0
@export var drop_speed = .25
@export var drop_deaccel = 0.01
@export var min_speed = .05
@export var rise_max_speed = 1.0
@export var rise_accel = 0.01

var speed 

var is_moving = false
var move_again = false
# Called when the node enters the scene tree for the first time.

var timer = 0
var init_pos
var drop_pos

func _ready():
	drop_pos = self.position + Vector2(0, drop_amount)
	init_pos = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_moving:
		speed = max(speed - drop_deaccel, min_speed)
		self.position = self.position.move_toward(drop_pos, speed)
	elif not is_moving and not self.position <= init_pos:
		speed = min(speed + rise_accel, rise_max_speed)
		self.position = self.position.move_toward(init_pos, speed)
	else:
		speed = min_speed
	if self.position.y >= drop_pos.y:
		is_moving = false
		speed = min_speed


func _on_area_2d_body_entered(body):
	if is_moving:
		move_again = true
	else:
		speed = abs(self.position.y - drop_pos.y) / (drop_pos.y - init_pos.y) * drop_speed
		is_moving = true
