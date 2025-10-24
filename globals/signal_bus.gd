extends Node

signal on_tile_clicked(tile: Tile, event: InputEvent)
signal on_flower_planted(tile: Tile, flower: Node)
signal on_skill_ui_clicked(skill_ui: Node)
signal on_skill_selected(skill: Skill)
signal on_flower_score_changed(flower_type: String, new_score: int)
signal on_skill_used(skill: Skill)
signal on_tile_hovered(tile: Tile)
signal on_score_changed(new_score: int)