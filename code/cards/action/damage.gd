extends CardAction


func apply(target: Node, power: int):
    target.stats.health -= power
