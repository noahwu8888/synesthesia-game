extends Node2D

@export var event: EventAsset
var instance: EventInstance

func _ready():
	instance = RuntimeManager.create_instance(event)


func _on_area_2d_body_entered(_body):
	instance.start()
	instance.release()
