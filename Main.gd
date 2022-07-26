extends Node2D

func _ready():
	randomize()
	$UI/startUp.visible = true
	$UI/dayContainer.visible = false

func _on_playBtn_pressed():
	$UI/startUp.queue_free() # removes startup nodes (forgot to include more comments)
	$UI/dayContainer.visible = true
	startDay()

func _process(_delta):
	if $UI/dayContainer/price/advertTxt.text.empty() || $UI/dayContainer/price/costTxt.text.empty() || $UI/dayContainer/price/makeTxt.text.empty():
		$UI/dayContainer/price/button.disabled = true
	else:
		$UI/dayContainer/price/button.disabled = false

func startDay():
	Global.profit = 0
	Global.currDay += 1
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
		Global.cost = Global.costToMake * int($UI/dayContainer/price/makeTxt.text) + int($UI/dayContainer/price/advertTxt.text) * Global.advertCost
		Global.sellPrice = float($UI/dayContainer/price/costTxt.text) * int($UI/dayContainer/price/makeTxt.text)
		print(Global.cost)
		print(Global.sellPrice)
		finaceReport()

func finaceReport():
	Global.assets -= Global.cost
	if $UI/dayContainer/weatherLbl.text == "sunny and dry" || $UI/dayContainer/weatherLbl.text == "sunny":
		if Global.sellPrice <= 0.15:
			Global.sellPrice = rand_range(0.02,0.15)
			Global.glassesSold = randi()%int($UI/dayContainer/price/makeTxt.text)+3
			Global.assets += Global.sellPrice * int($UI/dayContainer/price/makeTxt.text) - randi()%3+1
		else:
			Global.sellPrice = float($UI/dayContainer/price/costTxt.text)
			Global.glassesSold = randi()%int($UI/dayContainer/price/makeTxt.text)+7
			Global.assets += Global.sellPrice * int($UI/dayContainer/price/makeTxt.text) - randi()%4+1
		showStats()
	else:
		Global.sellPrice = rand_range(0.01, 0.05)
	print(Global.sellPrice)
	Global.glassesSold = randi()%int($UI/dayContainer/price/makeTxt.text)+5
	if Global.glassesSold != int($UI/dayContainer/price/makeTxt.text):
		Global.profit -= rand_range(0.01, 0.05)
	print(str(Global.preSell) + "yyy")
	if int($UI/dayContainer/price/makeTxt.text) <= 0:
		Global.profit = 0
	else:
		Global.profit = Global.assets - Global.preSell
	print(Global.profit)
	Global.assets += Global.sellPrice * int($UI/dayContainer/price/makeTxt.text) - randi()%6+1
	showStats()
	if Global.assets <= 0:
		handleBankru()

func showStats():
	if Global.glassesSold > int($UI/dayContainer/price/makeTxt.text):
		Global.glassesSold = int($UI/dayContainer/price/makeTxt.text)
	if int($UI/dayContainer/price/advertTxt.text) >= 1:
		Global.glassesSold = int($UI/dayContainer/price/makeTxt.text)
	$UI/dayContainer/financePanel/lblTwo.text = "Profit: $" + str(Global.profit)
	$UI/dayContainer/financePanel/lblFive.text = "Assets: $" + str(Global.assets)
	$UI/dayContainer/financePanel/lblThree.text = "Glasses made: " + str($UI/dayContainer/price/makeTxt.text)
	$UI/dayContainer/financePanel/lblFour.text = "Glasses sold: " + str(Global.glassesSold)
	$UI/dayContainer/price.visible = false
	$UI/dayContainer/financePanel.visible = true
	
func _on_quitBtn_pressed():
	get_tree().quit()

func handleBankru():
	$UI/dayContainer.visible = false
	$UI/bankruptPanel.visible = true
	$UI/bankruptPanel/assetLbl.text = "Assets: $" + str(Global.assets)

func _on_continBtn_pressed():
	$UI/dayContainer/price.visible = true
	$UI/dayContainer/financePanel.visible = false
	startDay()
