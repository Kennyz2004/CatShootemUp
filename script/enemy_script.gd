class_name Enemy extends Area2D

#check collision layers and how they work also check 29:50 of the video for a guide
#go to inspector to change the hp and spedd of enemy
@export var speed: int
@export var hp: int
@onready var laser_container = $EnemyLaserContainer
@onready var muzzle = $Sprite2D/muzzle


var laser_scene = preload('res://laser.tscn')

#going down
func _physics_process(delta):
	global_position.y += speed * delta
	pass
	
func shoot():
	var laser = laser_scene.instantiate()
	laser.speed = -300
	laser.global_position = muzzle.position
	laser_container.add_child(laser)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	shoot()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("shoot"):
		shoot()
	pass
	
func die():
	queue_free()

#to kill player
func _on_body_entered(body):
	if body is Player:
		body.take_dmg(0)
		take_dmg(0)
		
func take_dmg(amount):
	hp -= amount
	if hp <= 0:
		die()
		
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	pass # Replace with function body.

