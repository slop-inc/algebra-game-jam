extends State
class_name EnemyChase

var speed = 3


@onready var agent = self.get_parent().get_parent()
@onready var nav_agent = self.get_parent().get_parent().get_child(0)
@onready var player = null
@onready var anim = $"../../cultist"

func Enter():
	print("Entered Chase")
	print(agent)
	print(nav_agent)
	anim._run()

func Update(_delta: float):
	player = get_tree().get_first_node_in_group("player")
	if player and !agent.is_stunned and agent.is_on_floor():
		var target = Vector3 (player.position.x, agent.position.y, player.position.z)
		agent.look_at(target)

func Physics_Update(delta: float):	
	player = get_tree().get_first_node_in_group("player")
	if player and !agent.is_stunned and agent.is_on_floor():
		update_target_location(player.global_position)
		var current_location = agent.global_position
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		agent.velocity = new_velocity
		
		
		
	elif player and agent.is_stunned:
		print("stunned")
	elif !player and !agent.is_stunned:
		print("No player Located")
		Transitioned.emit(self,"idle")
		
	if agent.health <= 0:
		Transitioned.emit(self,"die")
	agent.move_and_slide()
	
	
	
	
	
	

func update_target_location(target_location):
	if player: 
		nav_agent.set_target_position(target_location)
		


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Transitioned.emit(self,"attack")
