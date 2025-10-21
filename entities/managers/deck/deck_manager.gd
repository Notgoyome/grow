extends Node
class_name DeckManager
@export var skills: Array[Skill] = [
	preload("res://skills/flowers/datas/red_flower.tres"),
	preload("res://skills/flowers/datas/yellow_flower.tres"),
	preload("res://skills/flowers/datas/blue_flower.tres"),
	preload("res://skills/flowers/datas/white_flower.tres"),
	preload("res://skills/flowers/datas/red_flower.tres"),
	preload("res://skills/flowers/datas/yellow_flower.tres"),
	preload("res://skills/flowers/datas/blue_flower.tres"),
	preload("res://skills/flowers/datas/white_flower.tres"),
]
@export var hand_size: int = 5

var selected_skill: Skill = null
signal on_hand_changed()
signal on_hand_erased(skill: Skill)
signal on_hand_appended(skill: Skill)
var hand: Array[Skill] = []
var discard_pile: Array[Skill] = []
var draw_pile: Array[Skill] = []

func _ready():
	shuffle_deck()
	try_draw_hand()
	SignalBus.on_skill_ui_clicked.connect(select_skill)


func select_skill(skill_ui: Node):
	if not skill_ui is FlowerSkillUI:
		return
	if skill_ui.skill not in hand:
		return
	
	selected_skill = skill_ui.skill
	SignalBus.on_skill_selected.emit(selected_skill)
	skill_ui.grow()


func consume_skill(skill: Skill, tile: Tile = null):
	if skill == null:
		return
	if (not skill.use(tile)):
		return
	if skill in hand:
		hand.erase(skill)
		on_hand_erased.emit(skill)
		discard_pile.append(skill)
		selected_skill = null
		draw_card()
		print_d()

func on_tile_clicked(tile: Tile, event: InputEvent):
	if hand.size() == 0:
		return
	var skill: Skill = selected_skill
	consume_skill(skill, tile)

func shuffle_deck():
	for skill in skills:
		var dup = skill.duplicate(true)
		draw_pile.append(dup)
	draw_pile.shuffle()
	discard_pile.clear()
	hand.clear()
	on_hand_changed.emit()

func reload_draw_pile():
	draw_pile = discard_pile.duplicate()
	draw_pile.shuffle()
	discard_pile.clear()

func try_draw_hand():
	while hand.size() < hand_size:
		draw_card()

func draw_card():
	if draw_pile.size() == 0:
		reload_draw_pile()
	var card: Skill = draw_pile.pop_back()
	if card == null:
		return
	print(card.IconUI)
	print(card.flower_type)
	hand.append(card)
	on_hand_appended.emit(card)

func print_d():
	print("Hand: ", hand.size(), " cards")
	print("Draw Pile: ", draw_pile.size(), " cards")
	print("Discard Pile: ", discard_pile.size(), " cards")
