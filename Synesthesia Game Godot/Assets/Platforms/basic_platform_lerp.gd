extends Node

@export var drop_amount = 30.0
@export var speed = 4.0

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
		self.position = self.position.lerp(drop_pos, delta * speed)
		print(self.position)
	elif not self.position <= init_pos:
		self.position = self.position.lerp(init_pos, delta * speed)
	if self.position.y >= drop_pos.y - .1:
		is_moving = false


func _on_area_2d_body_entered(body):
	if is_moving:
		move_again = true
	else:
		is_moving = true
