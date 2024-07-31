extends Node2D

var game_type: int
var can_move: bool = false
var cells: Array
var turn: int = 0
var chosenlang: int = 0
var move: int = 0

func _on_quit_button_pressed():
	$SFX/Click.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
func _on_ai_button_pressed():
	$SFX/Click.play()
	start_game(1)
func _on_button_pressed():
	$SFX/Click.play()
	start_game(0)
func _on_label_3_pressed():
	$SFX/Click.play()
	if chosenlang >= 5:
		chosenlang = 0
	else:
		chosenlang += 1
	match chosenlang:
		0:
			TranslationServer.set_locale('en')
		1:
			TranslationServer.set_locale('cmn')
		2:
			TranslationServer.set_locale('pl')
		3:
			TranslationServer.set_locale('fr')
		4:
			TranslationServer.set_locale('hr')
		5:
			TranslationServer.set_locale('sr')
func _on_label_3_mouse_entered():
	$SFX/Hover.play()
func _on_quit_button_mouse_entered():
	$SFX/Hover.play()
func _on_ai_button_mouse_entered():
	$SFX/Hover.play()
func _on_button_mouse_entered():
	$SFX/Hover.play()




func _on_zero_pressed():
	button_pressed(0)
func _on_one_pressed():
	button_pressed(1)
func _on_two_pressed():
	button_pressed(2)
func _on_three_pressed():
	button_pressed(3)
func _on_four_pressed():
	button_pressed(4)
func _on_five_pressed():
	button_pressed(5)
func _on_six_pressed():
	button_pressed(6)
func _on_seven_pressed():
	button_pressed(7)
func _on_eight_pressed():
	button_pressed(8)

func start_game(mode):
	$mainmenu.hide()
	move = 0
	turn = 0
	game_type = mode
	cells = [0,0,0,0,0,0,0,0,0]
	if game_type == 0:
		$"2Players/Label".text = 'PLAYER1_TURN'
		$"2Players".show()
		$AI.hide()
	elif game_type == 1:
		$AI.show()
		$"2Players".hide()
		$AI/Label.text = 'WELCOME'
		$AI/Sprite2D.frame = 3
	for a in 9:
		var sprite_path = "Cells/" + str(a)
		var sprite_node = get_node(sprite_path)
		sprite_node.frame = 0
	can_move = true

func check_win(cells):
	if (cells[0] == cells[1] and cells[1] == cells[2] and cells[1] != 0)\
	or (cells[3] == cells[4] and cells[4] == cells[5] and cells[4] != 0)\
	or (cells[6] == cells[7] and cells[7] == cells[8] and cells[7] != 0)\
	or (cells[0] == cells[3] and cells[3] == cells[6] and cells[3] != 0)\
	or (cells[1] == cells[4] and cells[4] == cells[7] and cells[4] != 0)\
	or (cells[2] == cells[5] and cells[5] == cells[8] and cells[5] != 0)\
	or (cells[0] == cells[4] and cells[4] == cells[8] and cells[4] != 0)\
	or (cells[2] == cells[4] and cells[4] == cells[6] and cells[4] != 0):
		return true
	else:
		return false

func button_pressed(button):
	if cells[button] == 0 and can_move:
		ai_reaction(button)
		await get_tree().create_timer(0.05).timeout
		if turn == 0:
			$SFX/Cross.play()
			var sprite_path = "Cells/" + str(button)
			var sprite_node = get_node(sprite_path)
			sprite_node.frame = 1
			cells[button] = 1
			turn = 1
		elif turn == 1:
			$SFX/Circle.play()
			var sprite_path = "Cells/" + str(button)
			var sprite_node = get_node(sprite_path)
			sprite_node.frame = 2
			cells[button] = 2
			turn = 0
		update()

func update():
	if check_win(cells) == true:
		can_move = false
		if game_type == 0:
			if turn == 0:
				$"2Players/Label".text = 'PLAYER2_WIN'
			elif turn == 1:
				$"2Players/Label".text = 'PLAYER1_WIN'
			end_game()
		elif game_type == 1:
			if turn == 0:
				ai_end_game(true)
			elif turn == 1:
				ai_end_game(false)
			can_move = false
	elif cells.find(0) == -1:
		$"2Players/Label".text = 'TIE'
		$AI/Label.text = 'TIE'
		$AI/Sprite2D.frame = 0
		can_move = false
		end_game()
	if check_win(cells) == false:
		if game_type == 0:
			if turn == 0:
				$"2Players/Label".text = 'PLAYER1_TURN'
			elif turn == 1:
				$"2Players/Label".text = 'PLAYER2_TURN'
		elif game_type == 1:
			if turn == 1:
				can_move = false
				ai_estimation()
			elif turn == 0:
				pass

func end_game():
	can_move = false
	await get_tree().create_timer(2.75).timeout
	$mainmenu.show()
func ai_end_game(aiwon):
	can_move = false
	if aiwon:
		$AI/Label.text = 'AI_WON'
		$AI/Sprite2D.frame = 3
	else:
		$AI/Label.text = 'AI_LOST'
		$AI/Sprite2D.frame = 2
	end_game()
func ai_estimation():
	var options: Array = [0,0,0,0,0,0,0,0,0]
	var sorted_options: Array = []
	var a0: int = 0
	var a1: int = 0
	var a2: int = 0
	var a3: int = 0
	var a4: int = 0
	var a5: int = 0
	var a6: int = 0
	var a7: int = 0
	var a8: int = 0
	var tempCells
	var ai_movement: Array = []
	var to_move:int = 0
	for a in 9:
		if cells[a] != 0:
			options[a] = -1000
	
	
	for i in 9:
		tempCells = cells.duplicate()
		if tempCells[i] == 0:
			tempCells[i] = 2
			if check_win(tempCells) == true:# winning now
				options[i] += 100
			for j in 9:
				tempCells = cells.duplicate()
				tempCells[i] = 2
				if tempCells[j] == 0:
					tempCells[j] = 1
					if check_win(tempCells) == true:# losing next
						options[i] += -1
						options[j] += 1
					for k in 9:
						tempCells = cells.duplicate()
						tempCells[i] = 2
						tempCells[j] = 1
						if tempCells[k] == 0:
							tempCells[k] = 2
							if check_win(tempCells) == true:# can win in 2
								options[i] += 1
							for l in 9:
								tempCells = cells.duplicate()
								tempCells[i] = 2
								tempCells[j] = 1
								tempCells[k] = 2
								if tempCells[l] == 0:
									tempCells[l] = 1
									if check_win(tempCells) == true:# can lose in 2
										options[i] += -1
										options[l] += 1
	
	
	a0 = options[0]
	a1 = options[1]
	a2 = options[2]
	a3 = options[3]
	a4 = options[4]
	a5 = options[5]
	a6 = options[6]
	a7 = options[7]
	a8 = options[8]
	sorted_options = [a0,a1,a2,a3,a4,a5,a6,a7,a8]
	sorted_options.sort()
	
	for z in 8:
		var to_remove = sorted_options.find(-1000)
		if to_remove != -1:
			sorted_options.pop_at(to_remove)
			
	var two_best: Array = []
	two_best.append(sorted_options.pop_back())
	two_best.append(sorted_options.pop_back())
	await get_tree().create_timer(randf_range(0.3,1.1)).timeout
	var which = randf()
	if which >= 0.03 and two_best[0] != null and two_best[1] != null:
		to_move = two_best.pop_front()
	elif which < 0.03 and two_best[0] != null and two_best[1] != null:
		to_move = two_best.pop_back()
	
	if to_move == a0:
		ai_movement.append(0)
	if to_move == a1:
		ai_movement.append(1)
	if to_move == a2:
		ai_movement.append(2)
	if to_move == a3:
		ai_movement.append(3)
	if to_move == a4:
		ai_movement.append(4)
	if to_move == a5:
		ai_movement.append(5)
	if to_move == a6:
		ai_movement.append(6)
	if to_move == a7:
		ai_movement.append(7)
	if to_move == a8:
		ai_movement.append(8)
	
	ai_movement.shuffle()
	var ai_movement_int = ai_movement.pop_front()
	match ai_movement_int:
		0:
			ai_move(0)
		1:
			ai_move(1)
		2:
			ai_move(2)
		3:
			ai_move(3)
		4:
			ai_move(4)
		5:
			ai_move(5)
		6:
			ai_move(6)
		7:
			ai_move(7)
		8:
			ai_move(8)

func ai_reaction(player_move):
	if move > 0:
		var options: Array = [0,0,0,0,0,0,0,0,0]
		var sorted_options: Array = []
		var a0: int = 0
		var a1: int = 0
		var a2: int = 0
		var a3: int = 0
		var a4: int = 0
		var a5: int = 0
		var a6: int = 0
		var a7: int = 0
		var a8: int = 0
		var tempCells
		var ai_movement: Array = []
		var to_move:int = 0
		for a in 9:
			if cells[a] != 0:
				options[a] = -1000
		
		for i in 9:
			tempCells = cells.duplicate()
			if tempCells[i] == 0:
				tempCells[i] = 1
				if check_win(tempCells) == true:# winning now
					options[i] += 100
				for j in 9:
					tempCells = cells.duplicate()
					tempCells[i] = 1
					if tempCells[j] == 0:
						tempCells[j] = 2
						if check_win(tempCells) == true:# losing next
							options[i] += -100
							options[j] += 200
						for k in 9:
							tempCells = cells.duplicate()
							tempCells[i] = 1
							tempCells[j] = 2
							if tempCells[k] == 0:
								tempCells[k] = 1
								if check_win(tempCells) == true:# can win in 2
									options[i] += 20
								for l in 9:
									tempCells = cells.duplicate()
									tempCells[i] = 1
									tempCells[j] = 2
									tempCells[k] = 1
									if tempCells[l] == 0:
										tempCells[l] = 2
										if check_win(tempCells) == true:# can lose in 2
											options[i] += -1
											options[l] += 1
		
		a0 = options[0]
		a1 = options[1]
		a2 = options[2]
		a3 = options[3]
		a4 = options[4]
		a5 = options[5]
		a6 = options[6]
		a7 = options[7]
		a8 = options[8]
		match player_move:
			0:
				player_move = a0
			1:
				player_move = a1
			2:
				player_move = a2
			3:
				player_move = a3
			4:
				player_move = a4
			5:
				player_move = a5
			6:
				player_move = a6
			7:
				player_move = a7
			8:
				player_move = a8
		sorted_options = [a0,a1,a2,a3,a4,a5,a6,a7,a8]
		sorted_options.sort()
		print(options)
		print(sorted_options)
		print(player_move)
		for z in 8:
			var to_remove = sorted_options.find(-1000)
			if to_remove != -1:
				sorted_options.pop_at(to_remove)
		if player_move == sorted_options[0]:
			$AI/Label.text = 'WHY_MOVE'
			$AI/Sprite2D.frame = 5
		elif player_move == sorted_options[-1]:
			$AI/Label.text = 'BEST_MOVE'
			$AI/Sprite2D.frame = 2
		if sorted_options.size() >= 6:
			if player_move == sorted_options[1]:
				$AI/Label.text = 'GOOD_MOVE'
				$AI/Sprite2D.frame = 4
			elif player_move == sorted_options[2] or player_move == sorted_options[3]:
				$AI/Label.text = 'NOT_THE_BEST_MOVE'
				$AI/Sprite2D.frame = 3
			elif player_move == sorted_options[4]:
				$AI/Label.text = 'BAD_MOVE'
				$AI/Sprite2D.frame = 5
		elif sorted_options.size() == 5:
			if player_move == sorted_options[1]:
				$AI/Label.text = 'GOOD_MOVE'
				$AI/Sprite2D.frame = 4
			elif player_move == sorted_options[2]:
				$AI/Label.text = 'NOT_THE_BEST_MOVE'
				$AI/Sprite2D.frame = 3
			elif player_move == sorted_options[3]:
				$AI/Label.text = 'BAD_MOVE'
				$AI/Sprite2D.frame = 5
		elif sorted_options.size() == 4:
			if player_move == sorted_options[1] or player_move == sorted_options[2]:
				$AI/Label.text = 'NOT_THE_BEST_MOVE'
				$AI/Sprite2D.frame = 3
		elif sorted_options.size() == 3:
			if player_move == sorted_options[1]:
				$AI/Label.text = 'NOT_THE_BEST_MOVE'
				$AI/Sprite2D.frame = 3
	
	elif move == 0:
		if player_move == 0 or player_move == 2 or player_move == 6 or player_move == 8:
			$AI/Label.text = 'BEST_MOVE'
			$AI/Sprite2D.frame = 2
		elif player_move == 4:
			$AI/Label.text = 'GOOD_MOVE'
			$AI/Sprite2D.frame = 4
		else:
			$AI/Label.text = 'BAD_MOVE'
			$AI/Sprite2D.frame = 5
	move += 1

func ai_move(cell):
	$SFX/Circle.play()
	cells[cell] = 2
	var sprite_path = "Cells/" + str(cell)
	var sprite_node = get_node(sprite_path)
	sprite_node.frame = 2
	turn = 0
	can_move= true
	update()
