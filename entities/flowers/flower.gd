extends Node2D
class_name Flower
@onready var flower: AnimatedSprite2D = %Flower

var type: String:
	set(value):
		type = value
		_change_display(value)

func _change_display(new_type: String):
	flower.animation = new_type
	flower.play()
