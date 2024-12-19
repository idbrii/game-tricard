extends RigidBody3D

var health:int
var turn:int
var spawner:String

var matYellow = preload("res://misc/yellow.material")
var matBlack = preload("res://misc/black.material")

signal died
signal damaged

func setTurn(val:int):
	turn = val
	$LabelTurn.text = "Turn: " + str(turn)
	
func setHP(val:int):
	health = val
	$LabelHP.text = "HP: "+str(health)

func isDead() -> bool:
	return health <= 0

func spawn():
	setTurn(2)
	setHP(3)
	await get_tree().create_timer(0.1).timeout

func focus():
	$MeshInstance3D.material_override = matYellow

func unfocus():
	$MeshInstance3D.material_override = matBlack

func damage(val:int):
	await get_tree().create_timer(0.1).timeout
	setHP(max(health-val, 0))
	if isDead():
		died.emit(self)
	else:
		damaged.emit(self)

func tick():
	setTurn(max(turn-1, 0))
	await get_tree().create_timer(0.2).timeout
	if turn > 0:
		return
	await performAction()
	setTurn(2)

func performAction():
	print(spawner, " doing action")
	await get_tree().create_timer(1).timeout
