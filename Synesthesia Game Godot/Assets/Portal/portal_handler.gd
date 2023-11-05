extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Entrance.exit_node = $Exit
	$Entrance.exit_trigger = $Exit/Exit_Trigger
	$Exit.entrance_node = $Entrance
	$Exit.entrance_trigger =$Entrance/Entrance_Trigger


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
