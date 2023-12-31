class_name Player extends CharacterBody2D

#takes in a scene and location 
signal laser_shot(laser_scene, location) #signal is emmited when func shoot is made
signal killed
signal hp_update(hp)

@export var SPEED = 300.0
@export var hp: int
@export var rate_of_fire: float = 0.2 
@onready var muzzle= $PChar/muzzle
@onready var animation = $PChar
@onready var explodeAnim = $PChar/Explosion
@onready var explosionsound = $Explosion
@onready var bulletsound = $RocketBullet


#cooldown for holding the shoot button
var shoot_cd:= false

# when action to shoot laser is pressed this variable makes an instand of laser (with moving upward animation)
var laser_scene= preload('res://scenes/laser.tscn')

func _ready():
	hp_update.emit(hp)
	explodeAnim.play("default")
	animation.play("default")
	
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
	if(rotation >= -0.60 && rotation <= 0.60):
		rotation += direction.x * delta
	elif(rotation > -0.7 && rotation < -0.6 && direction.x > 0):
		rotation += direction.x * delta
	elif(rotation < 0.7 && rotation > 0.6 && direction.x < 0):
		rotation += direction.x * delta
	
	#clamping the player movement to be only on the screen
	global_position= global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
	
func shoot():
	#preload the scene and will go to gamerscrip.gd to play function
	#look at connect in ready
	laser_shot.emit(laser_scene, muzzle.global_position)
	bulletsound.play()
	
func take_dmg(amount):
	explosionsound.play()
	animation.play("hurt")
	hp -= amount
	hp_update.emit(hp)
	if hp <= 0:
		explodeAnim.play("death")
		await get_tree().create_timer(0.5).timeout
		die()
		
func die():
	#go to game on reday to find signal connect 
	killed.emit()
	queue_free()
