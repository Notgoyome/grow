extends Node2D
@onready var grass: AudioStreamPlayer = %Grass

var pitch_grass := 1.0

func play_grass_sound():
    # check how many sounds are playing
    if grass.playing:
        pitch_grass *= 1.1
    else:
        pitch_grass = 1.0
    grass.pitch_scale = pitch_grass
    grass.play()