extends Node2D
class_name WinStateManager

@export var action_per_round: int = 4
@export var score_to_next_round: int = 50
@onready var you_lose: Label = %YouLose
@onready var score: Label = %Score
@onready var round: Label = %Round
@onready var hands_remaining: Label = %HandsRemaining
var current_round: int = 1
var action_remaining: int = action_per_round:
    set(value):
        action_remaining = value
        hands_remaining.text = "Actions Left: %d" % action_remaining
var lost := false

func _ready():
    you_lose.visible = false
    score.text = "Score to next round: %d" % score_to_next_round
    round.text = "Round: %d" % current_round
    hands_remaining.text = "Hands remaining: %d" % action_remaining
    SignalBus.on_skill_used.connect(_on_skill_used)
        

func _on_skill_used(_skill: Skill):
    if lost:
        return
    action_remaining -= 1
    if action_remaining <= 0:
        if !check_win_state():
            lost = true
            you_lose.visible = true
        else:
            action_remaining = action_per_round


func _increase_score():
    score_to_next_round += score_to_next_round * 1.05 + 10
    score.text = "Score to next round: %d" % score_to_next_round

func check_win_state() -> bool:
    var player_data = GameGlobal.player_data
    if player_data.score >= score_to_next_round:
        current_round += 1
        action_per_round += 2
        player_data.score = 0
        round.text = "Round: %d" % current_round
        action_remaining = action_per_round
        _increase_score()
        return true
    return false