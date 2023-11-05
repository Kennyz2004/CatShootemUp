extends Node2D

# go to game node and under gamerscrip.gd adjust enemy size acc to how many enemy types there are
@export var enemy_scenes: Array[PackedScene]= []
@onready var player_spawn_pos = $PlayerSpawnPos
@onready var lazer_container = $LazerContainer
@onready var timer= $EnemySpawnTimer # connect signal
@onready var enemy_container= $EnemyContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen


var player = null #no player
var score := 0:
	set(value):
		score= value
		hud.score= score
var high_score


func _ready():
	#read the high score score that is saved in the file
	var save_File= FileAccess.open('user://save.data', FileAccess.READ)
	if save_File!=null:
		high_score= save_File.get_32()
	else:
		high_score=0 
		save_game()
		
	score=0
	player = get_tree().get_first_node_in_group("player") # find player
	assert(player!=null) #insert error if player is not found
	player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	var e = enemy_scenes[1].instantiate()
	e.global_position = Vector2(640, 100)
	enemy_container.add_child(e)
	player.killed.connect(_on_player_killed)
	
func save_game():
	#save game hight score to user file
	var save_File = FileAccess.open('user://save.data', FileAccess.WRITE)
	save_File.store_32(high_score)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("QUIT"):
		get_tree().quit()
	elif Input.is_action_just_pressed("RESET"):
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("SPEED"):
		player.SPEED = 600.0
	if Input.is_action_just_released("SPEED"):
		player.SPEED = 300.0
		
	#increase difficulty
	if timer.wait_time < 0.5:
		timer.wait_time -= delta*0.05
	elif timer.wait_time < 0.5:
		timer.wait_time= 0.5

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position =  location
	lazer_container.add_child(laser)

func _on_enemy_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser.speed = -500
	lazer_container.add_child(laser)
	
#spawning a new enemy
func _on_enemy_spawn_timer_timeout():
	#create a new enemy instance
	var e = enemy_scenes.pick_random().instantiate()
	#change enemy spawn vertical change param of rand if
	e.global_position= Vector2(randf_range(50,1150), -30)
	e.killed.connect(_on_enemy_killed)
	e.laser_shot.connect(_on_enemy_laser_shot)
	enemy_container.add_child(e) 

func _on_enemy_killed(points):
	score += points
	if score > high_score:
		high_score = score

func _on_player_killed():
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(1).timeout
	gos.visible = true
	
	
