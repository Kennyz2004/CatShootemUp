extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)

func _on_player_hp_update(hp):
	$Hearts.size.x = hp * 64
	pass # Replace with function body.
