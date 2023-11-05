extends Area2D

@export var entrance = false
var exit_node
var exit_trigger
var entrance_node
var entrance_trigger


var root_node
# Called when the node enters the scene tree for the first time.
func _ready():
	root_node = get_parent().get_parent()
	print(root_node.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	body.velocity = Vector2.ZERO
	if entrance:
		#Write something later to deactivate player script and wait for the exit trigger
		root_node.current_room += 1
		root_node.move_to_room(root_node.current_room)
		body.global_position = self.exit_trigger.global_position
	else:
		root_node.current_room -= 1
		root_node.move_to_room(root_node.current_room)
		body.global_position = self.entrance_trigger.global_position

