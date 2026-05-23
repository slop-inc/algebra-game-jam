extends Node3D

@onready var anim = $AnimationPlayer
@onready var texture2 = preload("res://scenes/enemy/materials/guy_fucked.tres")
@onready var mesh = $Armature/Skeleton3D/Cube
var attack_is_done = false
var attacking = false
var death_is_done = false
var dying = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _run():
	anim.play("Armature|run+loop")
	
func _attack():
	attack_is_done = false
	attacking = true
	anim.play("Armature|attack")
	
func _die():
	death_is_done = false
	dying = true
	mesh.set_surface_override_material(0, texture2)
	anim.play("Armature|death")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if attacking:
		print("attackDone")
		attack_is_done = true
		attacking = false
	elif dying:
		print("died")
		death_is_done = true
