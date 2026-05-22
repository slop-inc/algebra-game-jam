extends State
class_name EnemyAsleep

func Enter():
	print("Entered Sleep")
	
	
func Physics_Update(delta):
	_awake()
	

func _awake():
	print("Awoke")
	Transitioned.emit(self, "chase")
	
func Exit():
	print("Left Sleep")
