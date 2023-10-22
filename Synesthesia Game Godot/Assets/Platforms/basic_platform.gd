extends Node

@export var drop_amount = 30.0
@export var drop_time = 2.0

var is_moving = false
# Called when the node enters the scene tree for the first time.

var timer = 0
var init_y

func _ready():
	init_y = self.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_moving:
		timer += delta
		print(self.position.y)
		self.position.y = init_y + drop_amount*(timer/drop_time)*(1 - timer/drop_time)
	if timer >= drop_time:
		is_moving = false
		timer = 0

func _on_area_2d_body_entered(body):
	is_moving = true
