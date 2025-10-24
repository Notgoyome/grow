extends Node2D
class_name Flower
@export var _score: int = 10
@onready var flower: AnimatedSprite2D = %Flower
@onready var pivot: Node2D = %Pivot
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready():
	var tween = get_tree().create_tween()
	pivot.scale = Vector2(0.8, 0.0	)
	tween.tween_property(pivot, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pass

var type: String:
	set(value):
		type = value
		_change_display(value)

func _change_display(new_type: String):
	flower.animation = new_type
	flower.play()

func get_score() -> int:
	return _score

func crop_flower(delay_time: float = 0.0) -> void:
	await get_tree().create_timer(delay_time).timeout
	SoundGlobal.play_grass_sound()
	animation_player.play("Crop")
	await animation_player.animation_finished
	var tween = get_tree().create_tween()
	var goto = Vector2(0,0)
	tween.tween_property(self, "global_position", goto, 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()