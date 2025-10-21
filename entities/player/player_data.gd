extends Resource
class_name PlayerData

@export var flowers_count : Dictionary[String, int] = {
    "red": 0,
    "yellow": 0,
    "blue": 0,
    "white": 0
}

func increase_flower_score(flower_type: String, amount: int):
    if flower_type in flowers_count:
        flowers_count[flower_type] += amount

func get_flower_score(flower_type: String) -> int:
    if flower_type in flowers_count:
        return flowers_count[flower_type]
    return 0