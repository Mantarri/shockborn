extends Resource


export(float) var defaultHP

export(float) var currentHP
export(float) var currentHPModifiers

export(float) var speed
export(Dictionary) var speedModifiers

export(float) var jumpStrength
export(float) var jumpStrengthModifiers

export(float) var gravity
export(float) var gravityModifiers

export(int) var level
export(int) var experience

export(Resource) var type
export(int, "Physical", "Digital", "Normal") var style

export(int) var physicalAttack
export(int) var physicalDefense
export(int) var digitalAttack
export(int) var digitalDefense

export(Array) var moves = [
	null,
	null,
	null,
	null
]
