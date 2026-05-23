extends Node3D


@onready var anim = $AnimationPlayer
@onready var mesh = $Armature/Skeleton3D/arm3
@onready var arm = $Armature
var is_anim = false
var t = 0.0
var target
var current_pos
var base_pos


func _ready() -> void:
	mesh.visible = false
	base_pos = Vector3(arm.position)

func _punch():
	anim.play("Armature|Punch")
	
func _attack():
	anim.play("Armature|attack")
	
func _orb():
	anim.play("Armature|Evil orb")
	
func _physics_process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	is_anim = true
	mesh.visible = false


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	is_anim = true
	mesh.visible = true # Replace with function body.
