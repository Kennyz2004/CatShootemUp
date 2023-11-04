class_name  Player extends CharacterBody2D

#takes in a scene and location 
signal laser_shot(laser_scene, location) #signal is emmited when func shoot is made

@export var SPEED = 300.0
@export var hp = 5
@export var rate_of_fire := 0.1 
@onready var muzzle= $Sprite2D/muzzle


#cooldown for holding the shoot button
var shoot_cd:= false

# when action to shoot laser is pressed this variable makes an instand of laser (with moving upward animation)
var laser_scene= preload('res://laser.tscn')

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#action of the shooting (left click)
func _process(delta):
	#keep checking while pressed
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd= true
			shoot()
			#rate of fire of the hold shooting
			await get_tree().create_timer(rate_of_fire).timeout
			#shoot
			shoot_cd= false
			
			
func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity= direction * SPEED
	move_and_slide()
	
func shoot():
	#preload the scene and will go to gamerscrip.gd to play function
	#look at connect in ready
	laser_shot.emit(laser_scene, muzzle.global_position)
	
func take_dmg(amount):
	hp -= amount
	if hp <= 0:
		die()
		
func die():
	queue_free()
