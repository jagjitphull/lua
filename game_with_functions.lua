function display_menu()
		--display a menu
		print("-----------------------------")
		print("Welcome,"..os.date())
		print("-----------------------------")
		print("| 1. Generate random enemy position")
		print("| 2. Distance from enemy to player")
		print("| 3. Get angle from enemy to player")
		print("| 4. Exit")
end

function get_distance(x1,y1,x2,y2)
	local dist = math.sqrt((x1-x2)^2 + (y1-y2)^2)
	return dist
end

local user_option = 0

local player_x,player_y = 400,300
local enemy_x,enemy_y = 0,0

while user_option ~= 4
	do
		display_menu()

		--read the user options from the keyboard
		user_option = io.read("*n")

		if user_option == 1
			then
				enemy_x = math.random(0,800)
				enemy_y = math.random(0,600)
				print("Enemy Position ("..enemy_x ..","..enemy_y..")")
			end

		if user_option == 2
			then
				--local distance = math.sqrt((enemy_x-player_x)^2 + (enemy_y + player_y)^2)
				local distance =  get_distance(enemy_x,enemy_y, player_x, player_y)
				print("Distance from enemy to player: "..distance)
			end

		if user_option == 3
			then
				local arct = math.atan2((enemy_y-player_y),(enemy_x-player_x))
				local degrees = math.deg(arct)
				print("Angle between the enemy and player is: "..degrees.." degrees")
			end

		end
		print("Thank you, Game Over")
