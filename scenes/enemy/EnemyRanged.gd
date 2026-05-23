extends State
class_name EnemyRanged

@onready var PROJECTILE = preload("res://scenes/enemy/Fireball.tscn")
@onready var agent = self.get_parent().get_parent()
@onready var player = get_tree().get_first_node_in_group("player")
@onready var anim = $"../../cultist"

var last_shot = 0
var has_shot = false

func Enter():
	#print("Entered Ranged Attack")
	pass

func Physics_Update(_delta: float):
	if !has_shot:
		_shoot_projectile()
	elif has_shot:
		if last_shot < 2:
			last_shot += 1 * _delta
		elif last_shot >= 0.4:
			last_shot = 0
			has_shot = false
			
	if agent.health <= 0:
		Transitioned.emit(self,"die")
	agent.move_and_slide()
		
func Update(_delta: float):
	var target = Vector3 (player.position.x, agent.position.y, player.position.z)
	agent.look_at(target)
	
func _shoot_projectile():
	anim._attack()
	has_shot = true
	var projectile = PROJECTILE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = Vector3(agent.global_position.x, agent.global_position.y + 0.5, agent.global_position.z)
	projectile.dir = agent.global_position.direction_to(player.global_position)
	
