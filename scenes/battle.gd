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
    SelectAll,
    PlayerTurn,
    EnemyTurn,
}

var mode:Mode
var currentSelection:Enemy
var enemies:Dictionary
var enemyCooldown:Dictionary = {
    "A": 1,
    "B": 0,
    "C": 2,
    "BossSpawnPoint": 5,
}
var enemy_types:Array = [
    PrefabCowboy,
    PrefabGoblin,
    PrefabDemon,
    PrefabFireBat,
    PrefabKillyote,
    PrefabSnake,
]
var maxEnemiesOut:int = 1
var maxSpawnPerRespawn:int = 1
var killCount:int = 0
@export var reqKillCount:int = 5

signal enemyPicked
signal allEnemiesDefeated

func _ready() -> void:
    mode = Mode.Intro
    await spawnEnemies()
    mode = Mode.None

func _process(_delta: float) -> void:
    if mode == Mode.Select:
        var en = getEnemyAtMouse()
        set_enemy_focus(en)
        if en != null and Input.is_action_just_pressed("click"):
            mode = Mode.None
            set_enemy_focus(null)
            self.enemyPicked.emit(en)
    elif mode == Mode.SelectAll:
        var en = getEnemyAtMouse()
        if en:
            if Input.is_action_just_pressed("click"):
                self.enemyPicked.emit(en)
            else:
                for victim: Enemy in enemies.values():
                    victim.focus()
        else:
            for victim: Enemy in enemies.values():
                victim.unfocus()


func set_enemy_focus(en:Enemy):
    if en != currentSelection:
        if currentSelection != null:
            currentSelection.unfocus()
            prints(currentSelection.name, "lost focus")
        if en != null:
            prints(en.name, "in focus")
            en.focus()
    currentSelection = en

func spawn(type, n:Node3D):
    var en:Enemy = type.instantiate()
    en.position = n.position
    en.spawner = n.name
    en.disposable.connect(_on_enemy_disposable)
    en.died.connect(_on_enemy_died)
    en.visible = false
    enemies[n.name] = en
    add_child(en)
    en.spawn()
    print("spawned enemy at ", n.name)

func spawnEnemies():
    randomize()
    var isBossOut = enemies.has($BossSpawnPoint.name)
    var shouldSpawnBoss = killCount >= reqKillCount and !isBossOut
    var spawned:int = 0
    var out:int = enemies.size()
    for n:Node3D in $SpawnPoints.get_children():
        if out + spawned >= maxEnemiesOut:
            break
        if enemies.has(n.name):
            continue
        if enemyCooldown[n.name] > 0:
            continue
        if n.name == "B" and (isBossOut or shouldSpawnBoss):
            continue
        var i:int = randi() % enemy_types.size()
        var type = enemy_types[i]
        spawn(type, n)
        spawned += 1
        if spawned >= maxSpawnPerRespawn:
            break
    # Special spawn boss logic
    if shouldSpawnBoss:
        spawn(PrefabBossilisk, $BossSpawnPoint)

func selectEnemy():
    mode = Mode.Select

func startEnemyTurn(player:Player):
    mode = Mode.EnemyTurn
    var que = enemies.values()
    for n:Enemy in que:
        if n.status.is_dead():
            continue
        await n.tick(player)
    await get_tree().create_timer(0.2).timeout
    await spawnEnemies()
    mode = Mode.None

func _on_enemy_died(en:Enemy):
    print("deregistering enemy")
    killCount += 1
    enemies.erase(en.spawner)
    maxSpawnPerRespawn = max(maxSpawnPerRespawn+1, 2)
    maxEnemiesOut = max(maxEnemiesOut+1, 4)
    for key in enemyCooldown:
        var count:int = enemyCooldown[key]
        enemyCooldown[key] = max(count-1, 0)
    if enemyCooldown[en.spawner] == 0:
        enemyCooldown[en.spawner] += 1

func _on_enemy_disposable(en:Enemy):
    print("disposing enemy")
    remove_child(en)
    if en.spawner == $BossSpawnPoint.name:
        allEnemiesDefeated.emit()

func getEnemyAtMouse(ray_len:int = 1000) -> Enemy:
    var space_state = get_world_3d().direct_space_state
    var cam = $Camera
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
