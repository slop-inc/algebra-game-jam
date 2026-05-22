extends State
class_name EnemyAttack

@onready var attack_area = $"../../AttackArea"
@onready var anim = $"../../cultist"
@onready var agent = self.get_parent().get_parent()
var has_attacked = false

func Enter():
	print("Entered Attack")
	has_attacked = false
	anim._attack()
	_attack()
	
func _attack():
	await get_tree().create_timer(0.5).timeout
	print("attacked")
	var hits = attack_area.get_overlapping_bodies()
	var player
	for i in hits:
		if i.is_in_group("player"):
			player = i
	
	if player:
		print(player)
		has_attacked = true
	else:
		print("found no player")
		has_attacked = true	
	
		
	
	

func Physics_Update(_delta: float):
	if anim.attack_is_done:
		Transitioned.emit(self, "chase")
	agent.move_and_slide()

func Exit():
	print("Exited Attack")
