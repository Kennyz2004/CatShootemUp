class_name Enemy extends Area2D

signal killed(points)
signal laser_shot(laser_scene, location)

#check collision layers and how they work also check 29:50 of the video for a guide
#go to inspector to change the hp and spedd of enemy
@export var speed: Vector2
@export var hp: int
@onready var laser_container = $EnemyLaserContainer
@onready var muzzle = $Sprite2D/muzzle
@onready var explosionsound = $Explosion
@onready var bulletsound = $PizzaBullet
@onready var explodeAnim = $Sprite2D/Explosion
@export var points = 100
@export var rate_of_fire: float
var live: bool = false
var ogSpeed = speed

var laser_scene = preload('res://scenes/laser.tscn')

#going down
func _physics_process(delta):
	global_position += speed * delta
	pass
	
func shoot():
	laser_shot.emit(laser_scene, muzzle.global_position)
	bulletsound.play()
	await get_tree().create_timer(rate_of_fire).timeout
	shoot()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.3).timeout
	shoot()
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func die():
	bulletsound.play()
	queue_free()

#to kill player
func _on_body_entered(body):
	if body is Player:
		body.take_dmg(1)
		take_dmg(1)

func _on_area_entered(area):
	if area is Enemy:
		area.speed.y = speed.y - 50
		area.speed.x = randi_range(-100, 100)
	pass # Replace with function body.

func take_dmg(amount):
	explosionsound.play()
	explodeAnim.play("2")
	hp -= amount
	if hp <= 0:		
		explosionsound.play()
		explodeAnim.play("death")
		await get_tree().create_timer(0.5).timeout
		#points are now added
		killed.emit(points)
		die()

func _on_visible_on_screen_notifier_2d_screen_entered():
	live = true
	pass # Replace with function body
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	if(live == false):
		return
	killed.emit(-points)
	queue_free()
	pass # Replace with function body.

