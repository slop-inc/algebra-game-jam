extends State
class_name EnemyAttack

@onready var attack_area = $"../../AttackArea"
var has_attacked = false

func Enter():
	print("Entered Attack")
	has_attacked = false
	_attack()
	
func _attack():
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
	if has_attacked:
		Transitioned.emit(self, "chase")

func Exit():
	print("Exited Attack")
