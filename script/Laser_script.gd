extends Area2D

@export var speed = 600
# in inspector we can try to give different lazers (if we want that) to give more dmg
@export var damage = 1
@export var boolet: AnimatedSprite2D
var player: bool

func _ready():
	boolet.play("0")
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	global_position.y += -speed * delta
	pass
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

#laser interacts with the enemy (check at collision layer)
func _on_area_entered(area):
	if area is Enemy && player == true:
		boolet.play("1")
		speed = 0
		area.take_dmg(damage) # die function
		await get_tree().create_timer(0.3).timeout
		queue_free() #remove laser

func _on_body_entered(body):
	if body is Player && player == false: 
		boolet.play("1")
		speed = 0
		body.take_dmg(damage)
		await get_tree().create_timer(0.3).timeout
		queue_free()
	pass # Replace with function body.
