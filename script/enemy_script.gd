class_name Enemy extends Area2D

#check collision layers and how they work also check 29:50 of the video for a guide

#go to inspector to change the hp and spedd of enemy
@export var speed= 150
@export var hp=1

#going down
func _physics_process(delta):
	global_position.y += speed * delta


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func die():
	queue_free()

#to kill player
func _on_body_entered(body):
	if body is Player:
		body.take_dmg()
		die()
		
func take_dmg(amount):
	hp -= amount
	if hp <= 0:
		die()
		
