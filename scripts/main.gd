extends Node2D

var game_type: int
var can_move: bool = false
var cells: Array
var turn: int = 0
var chosenlang: int = 0
var cells_in_game: Array

func _on_zero_pressed():
	if cells[0] == 0 and can_move:
		if turn == 0:
			$"Cells/0".frame = 1
			cells[0] = 1
			turn = 1
		elif turn == 1:
			$"Cells/0".frame = 2
			cells[0] = 2
			turn = 0
		update()
	else:
		pass
func _on_one_pressed():
	if cells[1] == 0 and can_move:
		if turn == 0:
			$"Cells/1".frame = 1
			cells[1] = 1
			turn = 1
		elif turn == 1:
			$"Cells/1".frame = 2
			cells[1] = 2
			turn = 0
		update()
	else:
		pass
func _on_two_pressed():
	if cells[2] == 0 and can_move:
		if turn == 0:
			$"Cells/2".frame = 1
			cells[2] = 1
			turn = 1
		elif turn == 1:
			$"Cells/2".frame = 2
			cells[2] = 2
			turn = 0
		update()
	else:
		pass
func _on_three_pressed():
	if cells[3] == 0 and can_move:
		if turn == 0:
			$"Cells/3".frame = 1
			cells[3] = 1
			turn = 1
		elif turn == 1:
			$"Cells/3".frame = 2
			cells[3] = 2
			turn = 0
		update()
	else:
		pass
func _on_four_pressed():
	if cells[4] == 0 and can_move:
		if turn == 0:
			$"Cells/4".frame = 1
			cells[4] = 1
			turn = 1
		elif turn == 1:
			$"Cells/4".frame = 2
			cells[4] = 2
			turn = 0
		update()
	else:
		pass
func _on_five_pressed():
	if cells[5] == 0 and can_move:
		if turn == 0:
			$"Cells/5".frame = 1
			cells[5] = 1
			turn = 1
		elif turn == 1:
			$"Cells/5".frame = 2
			cells[5] = 2
			turn = 0
		update()
	else:
		pass
func _on_six_pressed():
	if cells[6] == 0 and can_move:
		if turn == 0:
			$"Cells/6".frame = 1
			cells[6] = 1
			turn = 1
		elif turn == 1:
			$"Cells/6".frame = 2
			cells[6] = 2
			turn = 0
		update()
	else:
		pass
func _on_seven_pressed():
	if cells[7] == 0 and can_move:
		if turn == 0:
			$"Cells/7".frame = 1
			cells[7] = 1
			turn = 1
		elif turn == 1:
			$"Cells/7".frame = 2
			cells[7] = 2
			turn = 0
		update()
	else:
		pass
func _on_eight_pressed():
	if cells[8] == 0 and can_move:
		if turn == 0:
			$"Cells/8".frame = 1
			cells[8] = 1
			turn = 1
		elif turn == 1:
			$"Cells/8".frame = 2
			cells[8] = 2
			turn = 0
		update()
	else:
		pass
func update():
	print("board: " + str(cells))
	if check_win() == true:
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
	elif cells.find(0) == -1:
		$"2Players/Label".text = 'TIE'
		$AI/Label.text = 'TIE'
		end_game()
	if check_win() == false:
		if game_type == 0:
			if turn == 0:
				$"2Players/Label".text = 'PLAYER1_TURN'
			elif turn == 1:
				$"2Players/Label".text = 'PLAYER2_TURN'
		elif game_type == 1:
			if turn == 1:
				print('player moved')
				can_move = false
				ai_estimation()
			elif turn == 0:
				print('ai moved')
func _on_quit_button_pressed():
	get_tree().quit()
func _on_ai_button_pressed():
	start_game(1)
func _on_button_pressed():
	start_game(0)
func start_game(mode):
	$mainmenu.hide()
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
	await get_tree().create_timer(0.5).timeout
	can_move = true
func end_game():
	await get_tree().create_timer(2.75).timeout
	$mainmenu.show()
	turn = 0
func ai_end_game(aiwon):
	if aiwon:
		$AI/Label.text = 'AI_WIN'
		$AI/Sprite2D.frame = 3
	else:
		$AI/Label.text = 'AI_LOST'
		$AI/Sprite2D.frame = 4
	end_game()
func ai_estimation():
	print('estimating')
	cells_in_game = cells
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
	for a in 9:
		if cells[a] != 0:
			options[a] = -1000
	for i in 9:
		if cells[i] == 0:
			cells[i] = 2
			if check_win() == true:# winning now
				options[i] += 500
				cells[i] = 0
				continue
			for j in 8:
				if cells[j] == 0:
					cells[j] = 1
					if check_win() == true:# losing next
						options[i] += 400
						cells[i] = 0
						cells[j] = 0
						continue
					for k in 8:
						if cells[k] == 0:
							cells[k] = 2
							if check_win() == true: #can win in 2
								options[i] += 100
								cells[i] = 0
								cells[j] = 0
								cells[k] = 0
								continue
							for l in 8:
								if cells[l] == 0:
									cells[l] = 1
									if check_win() == true: # can lose in 2
										options[i] += 50
									cells[i] = 0
									cells[j] = 0
									cells[k] = 0
									cells[l] = 0
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
	print('options: ' + str(options))
	print('sorted_options: ' + str(sorted_options))
	var to_move = sorted_options.pop_back()
	var ai_movement = 0
	if to_move == a0:
		ai_movement = 0
	elif to_move == a1:
		ai_movement = 1
	elif to_move == a2:
		ai_movement = 2
	elif to_move == a3:
		ai_movement = 3
	elif to_move == a4:
		ai_movement = 4
	elif to_move == a5:
		ai_movement = 5
	elif to_move == a6:
		ai_movement = 6
	elif to_move == a7:
		ai_movement = 7
	elif to_move == a8:
		ai_movement = 8
	match ai_movement:
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
func ai_reaction(reaction):
	match reaction:
		0:
			pass

func ai_move(cell):
	cells = cells_in_game
	cells[cell] = 2
	var sprite_path = "Cells/" + str(cell)
	var sprite_node = get_node(sprite_path)
	sprite_node.frame = 2
	turn = 0
	update()
	can_move = true

func _on_label_3_pressed():
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

func check_win():
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
