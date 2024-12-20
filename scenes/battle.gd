extends Node3D
class_name Battle

var EnemyPrefab = preload("res://scenes/enemies/cowboy.tscn")

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

signal enemyPicked

func _ready() -> void:
    mode = Mode.Intro
    await spawnEnemies()
    mode = Mode.None

func _process(delta: float) -> void:
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
    # TODO pick which enemy to spawn
    for n:Node3D in $Stage/SpawnPoints.get_children():
        if enemies.has(n.name):
            continue
        var en:Enemy = EnemyPrefab.instantiate()
        en.position = n.position
        en.spawner = n.name
        en.disposed.connect(onEnemyDisposed)
        enemies[n.name] = en
        add_child(en)
        en.spawn()
        print("spawned enemy at ", n.name)

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
    enemies.erase(en.spawner)
    remove_child(en)

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
