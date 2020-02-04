extends Control

var dict = {"1":20,"2":100,"3":1000,"what":10000}
var upgrades = {"1":20,"2":100,"3":1000,"what":10000}
var upgradevalues = {"1":20,"2":100,"3":1000,"what":10000}
func _ready():
	for i in dict.keys():
		print(dict[i])
	var iteration = 0
	var appendage = 0
	for e in upgrades.values():
		iteration += 1
		if int(e) > 0:
			var number = upgradevalues.values()[iteration]
			appendage += int(number)*int(e)
