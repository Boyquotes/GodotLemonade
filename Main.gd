extends Node2D

func _ready():
	randomize()
	$UI/startUp.visible = true
	$UI/dayContainer.visible = false

func _on_playBtn_pressed():
	$UI/startUp.queue_free() # removes startup nodes, after 8 secs
	$UI/dayContainer.visible = true
	startDay()
	
func startDay():
	Global.advertCost = 2.00
	Global.currDay += 1
	$UI/dayContainer/price/makeTxt.text = "0"
	$UI/dayContainer/sunny.visible = false
	$UI/dayContainer/sunnydry.visible = false
	$UI/dayContainer/cloudy.visible = false
	$UI/dayContainer/price/lblOne.text = "On day " + str(Global.currDay) + ", the cost to make lemonade is: " + str(Global.costToMake)
	$UI/dayContainer/price/lblTwo.text = "Assets: $" + str(Global.assets)
	$UI/dayContainer/weatherDayLbl.text = "weather report for day " + str(Global.currDay)
	$UI/dayContainer/price/lblFive.text = "$" + str(Global.advertCost) + " each"
	$UI/dayContainer/weatherLbl.text = Global.weatherTypes[randi()%3+0]
	if $UI/dayContainer/weatherLbl.text == "sunny":
		$UI/dayContainer/sunny.visible = true
	elif $UI/dayContainer/weatherLbl.text == "sunny and dry":
		$UI/dayContainer/sunnydry.visible = true
	elif $UI/dayContainer/weatherLbl.text == "cloudy":
		$UI/dayContainer/cloudy.visible = true

func _on_button_pressed():
		if $UI/dayContainer/price/advertTxt.text <= "0":
			Global.cost = Global.costToMake * int($UI/dayContainer/price/makeTxt.text)
		Global.cost = Global.costToMake * int($UI/dayContainer/price/makeTxt.text) + int($UI/dayContainer/price/advertTxt.text) * Global.advertCost
		print(Global.cost)
		finaceReport()

func finaceReport():
	Global.assets -= Global.cost
	if Global.assets <= 0:
		handleBankru()
	startDay()

func _on_quitBtn_pressed():
	get_tree().quit()

func handleBankru():
	$UI/dayContainer.visible = false
	$UI/bankruptPanel.visible = true
	$UI/bankruptPanel/assetLbl.text = "Assets: $" + str(Global.assets)
