extends Node2D

# go to game node and under gamerscrip.gd adjust enemy size acc to how many enemy types there are
@export var enemy_scenes: Array[PackedScene]= []
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var lazer_container = $LazerContainer
@onready var timer= $EnemySpawnTimer # connect signal
@onready var enemy_container= $EnemyContainer

var player = null #no player


func _ready():
	player = get_tree().get_first_node_in_group("player") # find player
	assert(player!=null) #insert error if player is not found
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	var e = enemy_scenes[1].instantiate()
	e.global_position = Vector2(640, 100)
	enemy_container.add_child(e)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("QUIT"):
		get_tree().quit()
	elif Input.is_action_just_pressed("RESET"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position =  location
	lazer_container.add_child(laser)

#spawning a new enemy
func _on_enemy_spawn_timer_timeout():
	#create a new enemy instance
	var e = enemy_scenes.pick_random().instantiate()
	#change enemy spawn vertical change param of rand if
	e.global_position= Vector2(randf_range(50,1150), 30)
	enemy_container.add_child(e) 


	
	
