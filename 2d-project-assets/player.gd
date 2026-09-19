extends CharacterBody2D

signal health_depleted

var health = 100.0

var coin_counter = 0
var speed_boost = 0

@onready var coin_label = %Label

func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right", 
	"move_up", "move_down")
	
	var speed = 600
	if (coin_counter > 4):
		speed_boost += 1
		coin_counter = 0

	if (speed_boost == 1):
		speed = 800
	if (speed_boost == 2):
		speed = 1000
	if (speed_boost == 3):
		speed = 1200

	velocity = direction * speed
	move_and_slide()
	
	
	
	
	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()

	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()



func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	coin_label.text = "coin count: " + str(coin_counter) + " / 5"


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		set_coin(coin_counter + 1)
		
