extends Area2D

@export var entrance = false
var exit_node
var exit_trigger
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if entrance:
		#Write something later to deactivate player script and wait for the exit trigger
		body.global_position = self.exit_node.global_position
