extends State
class_name EnemyAsleep

@onready var agent = self.get_parent().get_parent()

func Enter():
	#print("Entered Sleep")
	pass
	
	
func Physics_Update(delta):
	if agent.is_awake:
		print("!!!!")
		_awake()
	

func _awake():
	#print("Awoke")
	
	if agent.is_ranged:
		Transitioned.emit(self, "ranged")
	else:
		Transitioned.emit(self, "chase")
func Exit():
	#print("Left Sleep")
	pass
