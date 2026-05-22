extends CharacterBody3D

var max_health = 100
var health = 100
var is_stunned = false
var stun_time = 0
var explode = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func _physics_process(delta: float) -> void:
	if is_stunned:
		if stun_time < 0.4:
			stun_time += 1 * delta
			print(is_stunned)
		else:
			stun_time = 0
			is_stunned = false
			print(is_stunned)
			
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
func _takeDamage(dmg: int):
	health = health - dmg
	print("got hit")
	
func _getKicked(dmg: int, kick_direction: Vector3):
	print("i got kicked")
	health = health - dmg
	is_stunned = true
	print(is_stunned)
	velocity.x = kick_direction.x * 15
	velocity.z = kick_direction.z * 15
	velocity.y = kick_direction.y * 15
	


func _on_instakill_detector_body_entered(body: Node3D) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if body == player and player.dashed_bool or player.slamed_bool:
		explode = true
		health = 0
		
		
