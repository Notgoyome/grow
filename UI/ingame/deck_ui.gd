extends Node2D

@export var deck_manager: DeckManager

var skills : Array[Skill] = []
var skill_ui: Array[Node] = []

func _ready():
	deck_manager.on_hand_appended.connect(on_hand_appended)
	deck_manager.on_hand_erased.connect(on_hand_erased)

func on_hand_appended(skill: Skill):
	skills.append(skill)
	var ui = skill.IconUI.instantiate()
	add_child(ui)
	skill.setup_icon_ui(ui)
	skill_ui.append(ui)
	_update_skill_ui_positions()

func on_hand_erased(skill: Skill):
	var index = find_by_instance(skill)
	if index == -1:
		return
		
	skills.erase(skill)
	var ui = skill_ui[index]
	skill_ui.erase(ui)
	ui.queue_free()

func find_by_instance(s: Skill) -> int:
	for i in range(skills.size()):
		if skills[i].get_instance_id() == s.get_instance_id():
			print("found at index:", i)
			print(skills[i], "==", s)
			return i
	return -1

func _update_skill_ui_positions():
	skill_ui[skills.size() - 1].position = Vector2(0, (skills.size()) * 18)
	for i in range(skill_ui.size()):
		var tween = get_tree().create_tween()
		var ui = skill_ui[i]
		tween.tween_property(ui, "position", Vector2(0, i * 18), 0.2)
