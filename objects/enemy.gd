extends RigidBody3D

var spawner:String
@onready var status := $Status as Status

var matYellow = preload("res://misc/yellow.material")
var matBlack = preload("res://misc/black.material")

signal disposed

func _ready():
	status.die.connect(onDied)
	status.hurt.connect(onHurt)
	status.blocked.connect(onBlocked)

func spawn():
	status.reset()
	await get_tree().create_timer(0.1).timeout
	# TODO anim

func focus():
	$MeshInstance3D.material_override = matYellow

func unfocus():
	$MeshInstance3D.material_override = matBlack

func onDied():
	$Model/AnimationPlayer.play("enemy_anim_dead")
	await $Model/AnimationPlayer.animation_finished
	$UI/LabelHP.text = "0"
	disposed.emit(self)

func onHurt():
	await get_tree().create_timer(0.1).timeout
	$Model/AnimationPlayer.play("enemy_anim_hurt")
	await $Model/AnimationPlayer.animation_finished
	$UI/LabelHP.text = str(status.health)

func onBlocked():
	await get_tree().create_timer(0.1).timeout
	# TODO play anim

func tick():
	await get_tree().create_timer(0.2).timeout
	status.mod_turns(-1)
	if status.turns <= 0:
		await performAction()
		status.reset_turns()

func performAction():
	print(spawner, " doing action")
	await get_tree().create_timer(1).timeout
