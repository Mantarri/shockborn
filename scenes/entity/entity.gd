extends KinematicBody

class_name Entity

export(String) var entityId

var entityData : Resource
var activeMove : int = 0


func attack():
	var moveDamage : float = entityData.moves[activeMove].damage
	var entityType : Resource = entityData.type
	var type : Resource = entityData.moves[activeMove].type
	var fightStyle : int = entityData.moves[activeMove].style
	var physicalAttack : int = entityData.physicalAttack
	var digitalAttack : int = entityData.digitalAttack
	
	# Entity attack power based on fighting style
	var entityEffectiveAttack : float
	
	if fightStyle == entityData.style:
		
		# Physical Fighting Type
		if fightStyle == 0:
			entityEffectiveAttack = physicalAttack * 1.5
		
		# Special Fighting Type
		elif fightStyle == 1:
			entityEffectiveAttack = digitalAttack * 1.5
		
		# Normal Fighting Type
		elif fightStyle == 2:
			entityEffectiveAttack = (physicalAttack + digitalAttack) / 2.0
	
	if type == entityType:
		entityEffectiveAttack *= 2
	
	
	var damage : float = (
		(entityData.level / 2.0) * (moveDamage * entityEffectiveAttack))
	
	var attackDetails : Dictionary = {
		"Damage": damage,
		"Type": type,
		"FightStyle": fightStyle,
	}
	
	return(attackDetails)

func receive_attack(attackDetails : Dictionary):
	var damage : float = attackDetails.damage
	var type : Resource = attackDetails.type
	var fightStyle : int = attackDetails.style
	
	for immuneType in entityData.type.immune:
		if immuneType.name == type.name:
			print("Entity is immune to move")
			return
