extends Area2D

@export var speed = 600
# in inspector we can try to give different lazers (if we want that) to give more dmg
@export var damage = 1
@export var sprite2D: Sprite2D

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	global_position.y += -speed * delta
	pass
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


#laser interacts with the enemy (check at collision layer)
func _on_area_entered(area):
	if area is Enemy:
		area.take_dmg(damage) # die function
		queue_free() #remove lazer
	if area is Player:
		area.take_dmg(damage)
		print("pain")
		queue_free()
