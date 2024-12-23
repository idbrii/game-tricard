extends RigidBody3D
class_name Enemy

var spawner: String
var actionIndex: int
@onready var status := $Status as Status
@onready var actions := $Actions.get_children()

signal disposable(n)
signal died(n)


func _ready():
    status.die.connect(onDied)
    status.hurt.connect(onHurt)
    status.blocked_damage.connect(onBlocked)


func spawn():
    actionIndex = actions.size() - 1
    status.reset()
    updateLabels()
    visible = true
    $Model/AnimationPlayer.play("enemy_anim_appear")
    await $Model/AnimationPlayer.animation_finished


func updateLabels():
    $UI.update_labels()


func focus():
    $Model/AnimationPlayer.play("enemy_anim_highlightedloop")


func unfocus():
    idle()


func idle():
    #~ print("Playing IDLE")
    $Model/AnimationPlayer.stop()
    $Model/AnimationPlayer.play("RESET")
    #$Model/AnimationPlayer.play("enemy_anim_idle")


func onDied():
    died.emit(self)
    $Model/AnimationPlayer.play("enemy_anim_hurt")
    $SFX/Hurt.play()
    await $Model/AnimationPlayer.animation_finished
    updateLabels()
    $Model/AnimationPlayer.play("enemy_anim_dead")
    $SFX/Die.play()
    await $Model/AnimationPlayer.animation_finished
    disposable.emit(self)
    prints(spawner, "died")


func onHurt(_amount: int):
    #$VFX/HeartBreak/AnimationPlayer.play("particle_play")
    $Model/AnimationPlayer.play("enemy_anim_hurt")
    $SFX/Hurt.play()
    await $Model/AnimationPlayer.animation_finished
    updateLabels()
    idle()
    prints(spawner, "hurt")


func onBlocked(_amount: int):
    updateLabels()
    await get_tree().create_timer(0.1).timeout
    $VFX/GuardBreak/AnimationPlayer.play("particle_play")
    $SFX/ArmorBreak.play()
    idle()


func tick(player: Player):
    prints(spawner, "ticking")
    await get_tree().create_timer(0.1).timeout
    status.mod_turns(-1)
    updateLabels()
    if status.turns <= 0 and status.health > 0:
        await performAction(player)
        status.reset_turns()
    updateLabels()
    await get_tree().create_timer(0.1).timeout
    status.end_turn()
    updateLabels()


func performAction(player: Player):
    if actionIndex >= actions.size():
        actionIndex = 0
    var action: Action = actions[actionIndex]
    prints(spawner, "executing action with power", action.power)
    for move: Action.Move in action.moves:
        prints(spawner, "using move", move)
        if move == Action.Move.Attack:
            $Model/AnimationPlayer.play("enemy_anim_fire")
            $SFX/Attack.play()
            await $Model/AnimationPlayer.animation_finished
            player.status.mod_health(-action.power)
        elif move == Action.Move.Heal:
            status.mod_health(action.power)
            $SFX/Heal.play()
            $VFX/HeartGain/AnimationPlayer.play("particle_play")
        elif move == Action.Move.Block:
            status.mod_block(action.power)
            $SFX/ArmorGain.play()
            $VFX/GuardGain/AnimationPlayer.play("particle_play")
        elif move == Action.Move.Burn:
            $SFX/Attack.play()
            $Model/AnimationPlayer.play("enemy_anim_fire")
            await $Model/AnimationPlayer.animation_finished
            player.status.mod_burn(action.power)
        elif move == Action.Move.Poison:
            $SFX/Attack.play()
            $Model/AnimationPlayer.play("enemy_anim_fire")
            await $Model/AnimationPlayer.animation_finished
            player.status.mod_poison(action.power)
    idle()
    actionIndex += 1
