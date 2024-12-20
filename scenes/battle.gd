extends Node3D
class_name Battle

var PrefabCowboy = preload("res://scenes/enemies/cowboy.tscn")
var PrefabGoblin = preload("res://scenes/enemies/goblin.tscn")
var PrefabDemon = preload("res://scenes/enemies/demon.tscn")
var PrefabFireBat = preload("res://scenes/enemies/firebat.tscn")
var PrefabKillyote = preload("res://scenes/enemies/killyote.tscn")
var PrefabSnake = preload("res://scenes/enemies/snake.tscn")
var PrefabBossilisk = preload("res://scenes/enemies/bossilisk.tscn")

enum Mode {
    None,
    Intro,
    Select,
    PlayerTurn,
    EnemyTurn,
}

var mode:Mode
var currentSelection:Enemy
var enemies:Dictionary
var enemy_types:Array = [
    PrefabCowboy,
    PrefabGoblin,
    PrefabDemon,
    PrefabFireBat,
    PrefabKillyote,
    PrefabSnake,
]
var killCount:int

signal enemyPicked

func _ready() -> void:
    mode = Mode.Intro
    await spawnEnemies()
    mode = Mode.None

func _process(_delta: float) -> void:
    if mode == Mode.Select:
        var en = getEnemyAtMouse()
        if en != null:
            if en != currentSelection:
                if currentSelection != null:
                    currentSelection.unfocus()
                en.focus()
                currentSelection = en
            if Input.is_action_just_pressed("click"):
                currentSelection.unfocus()
                currentSelection = null
                mode = Mode.None
                self.enemyPicked.emit(en)
        elif currentSelection != null:
            currentSelection.unfocus()
            currentSelection = null

func spawnEnemies():
    randomize()
    for n:Node3D in $SpawnPoints.get_children():
        if enemies.has(n.name):
            continue
        var i:int = randi() % enemy_types.size()
        var type = enemy_types[i]
        var en:Enemy = type.instantiate()
        en.position = n.position
        en.spawner = n.name
        en.disposed.connect(onEnemyDisposed)
        enemies[n.name] = en
        add_child(en)
        en.spawn()
        print("spawned enemy at ", n.name)
    # Special spawn boss logic
    if killCount > 1 and !enemies.has($BossSpawnPoint.name):
        var n:Node3D = $BossSpawnPoint
        var en:Enemy = PrefabBossilisk.instantiate()
        en.position = n.position
        en.spawner = n.name
        en.disposed.connect(onEnemyDisposed)
        enemies[n.name] = en
        add_child(en)
        en.spawn()


func selectEnemy():
    mode = Mode.Select

func startEnemyTurn(player:Player):
    mode = Mode.EnemyTurn
    var que = enemies.values()
    for n:Enemy in que:
        if n.status.is_dead():
            continue
        await n.tick(player)
    await spawnEnemies()
    mode = Mode.None

func onEnemyDisposed(en:Enemy):
    killCount += 1
    enemies.erase(en.spawner)
    remove_child(en)
    # TODO if boss died then let's do game over!

func getEnemyAtMouse(ray_len:int = 1000) -> Enemy:
    var space_state = get_world_3d().direct_space_state
    var cam = $Camera3D
    var mousepos = get_viewport().get_mouse_position()
    var origin = cam.project_ray_origin(mousepos)
    var end = origin + cam.project_ray_normal(mousepos) * ray_len
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.collide_with_areas = true
    var result = space_state.intersect_ray(query)
    if result.is_empty():
        return null
    # TODO check if is Enemy
    return result.collider
