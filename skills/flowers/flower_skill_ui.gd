extends Node2D
class_name FlowerSkillUI
@onready var flower: AnimatedSprite2D = %Flower

var skill: FlowerSkill

func _ready():
	SignalBus.on_skill_ui_clicked.connect(reset)

func change_type(new_type: String):
	flower.animation = new_type
	flower.play()

func grow():
	%Display.scale = Vector2(1.2, 1.2)

func reset(skill_ui: Node):
	if skill_ui != self:
		%Display.scale = Vector2(1, 1)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SignalBus.on_skill_ui_clicked.emit(self)
	pass # Replace with function body.
