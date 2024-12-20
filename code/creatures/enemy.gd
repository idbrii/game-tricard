extends RigidBody3D
class_name Enemy

var spawner:String
@onready var status := $Status as Status

signal disposed

func _ready():
    status.die.connect(onDied)
    status.hurt.connect(onHurt)
    status.blocked.connect(onBlocked)

func spawn():
    status.reset()
    updateLabels()
    $Model/AnimationPlayer.play("enemy_anim_appear")
    await $Model/AnimationPlayer.animation_finished

func updateLabels():
    $UI/HP/Label.text = str(status.health)
    $UI/Turn/Label.text = str(status.turns)
    $UI/Block/Label.text = str(status.block)
    $UI/Burn/Label.text = str(status.burn)
    $UI/Poison/Label.text = str(status.poison)
    $UI/Block.visible = status.block > 0
    $UI/Burn.visible = status.burn > 0
    $UI/Poison.visible = status.poison > 0

func focus():
    $Model/AnimationPlayer.play("enemy_anim_highlightedloop")

func unfocus():
    idle()

func idle():
    $Model/AnimationPlayer.play("enemy_anim_idle")

func onDied():
    $Model/AnimationPlayer.play("enemy_anim_hurt")
    await $Model/AnimationPlayer.animation_finished
    updateLabels()
    $Model/AnimationPlayer.play("enemy_anim_dead")
    await $Model/AnimationPlayer.animation_finished
    disposed.emit(self)
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
    player.status.mod_health(-10) # TODO get strength stat
    idle()
