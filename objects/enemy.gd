extends RigidBody3D
class_name Enemy

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
	$UI/LabelHP.text = str(status.health)
	$UI/LabelBlock.text = str(status.block)
	$UI/LabelTurn.text = str(status.turns)
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

func onHurt(amount:int):
	$Model/AnimationPlayer.play("enemy_anim_hurt")
	await $Model/AnimationPlayer.animation_finished
	$UI/LabelHP.text = str(status.health)

func onBlocked(amount:int):
	$UI/LabelBlock.text = str(status.block)
	await get_tree().create_timer(0.1).timeout
	# TODO play anim

func tick(player:Player):
	await get_tree().create_timer(0.1).timeout
	status.mod_turns(-1)
	if status.turns <= 0:
		await performAction(player)
		status.reset_turns()

func performAction(player:Player):
	prints(spawner, "doing action")
	$Model/AnimationPlayer.play("enemy_anim_fire")
	await $Model/AnimationPlayer.animation_finished
	player.status.mod_health(-10) # TODO get strength stat
