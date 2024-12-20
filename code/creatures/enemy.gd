extends RigidBody3D
class_name Enemy

var spawner:String
@onready var status := $Status as Status

signal disposable(n)
signal died(n)

func _ready():
    status.die.connect(onDied)
    status.hurt.connect(onHurt)
    status.blocked.connect(onBlocked)

func spawn():
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
    #$Model/AnimationPlayer.play("enemy_anim_idle")
    $Model/AnimationPlayer.play("RESET")

func onDied():
    died.emit(self)
    $Model/AnimationPlayer.play("enemy_anim_hurt")
    await $Model/AnimationPlayer.animation_finished
    updateLabels()
    $Model/AnimationPlayer.play("enemy_anim_dead")
    await $Model/AnimationPlayer.animation_finished
    disposable.emit(self)
    prints(spawner, "died")

func onHurt(_amount:int):
    #$VFX/HeartBreak/AnimationPlayer.play("particle_play")
    $Model/AnimationPlayer.play("enemy_anim_hurt")
    await $Model/AnimationPlayer.animation_finished
    updateLabels()
    idle()
    prints(spawner, "hurt")

func onBlocked(_amount:int):
    updateLabels()
    await get_tree().create_timer(0.1).timeout
    $VFX/GuardBreak/AnimationPlayer.play("particle_play")
    idle()
    #await $VFX/GaurdBreak/AnimationPlayer.animation_finished

func tick(player:Player):
    prints(spawner, "ticking")
    await get_tree().create_timer(0.1).timeout
    status.mod_turns(-1)
    updateLabels()
    if status.turns <= 0:
        await performAction(player)
        status.reset_turns()
    updateLabels()

func performAction(player:Player):
    prints(spawner, "doing action")
    $Model/AnimationPlayer.play("enemy_anim_fire")
    await $Model/AnimationPlayer.animation_finished
    # TODO get strength stat
    player.status.mod_health(-1)
    idle()
