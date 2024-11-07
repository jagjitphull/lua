function display_menu()

  -- Display a menuy on the console
  print("-------------------------------------")
  print("| Welcome, "..os.date())
  print("-------------------------------------")
  print("| 1. Generate randome enemy position")
  print("| 2. Distance from enemy to player")
  print("| 3. Get angle from enemy to player")
  print("| 4. Exit")
  print("-------------------------------------")
end

function get_distance(x1,y1,x2,y2)
  local dist = math.sqrt((x1-x2)^2 + (y1 - y2)^2)
  return dist
end



local user_option = 0

--Updating declarations with tables.
--local player_x,player_y = 400,300
local player = {x=400,y=300}

--local enemy_x, enemy_y = 0,0
local enemy = {x=0,y=0}

while user_option ~= 4
do

display_menu()
-- read the user options from the keyboard
 user_option = io.read("*n")


-- dot syntax to refer to values, also square brackets notation.

  if user_option == 1 
  then
    enemy.x = math.random(0,800)
    enemy["y"] = math.random(0,600)
    print("Enemy position ("..enemy.x.. ","..enemy["y"]..")")
  end

 --option 2, created with get_distance function, defined above.
  if user_option == 2 
  then
    --local distance = get_distance(enemy_x,enemy_y,player_x,player_y)
    local distance = get_distance(enemy.x,enemy["y"],player.x,player.y)
    print("Distance from enemy to player: ".. distance)
  end

  if user_option == 3 
  then
    local arct = math.atan2((enemy.y-player.y),(enemy.x-player.x))
   -- local degrees = math.deg(arct)
    print("Angle between enemy and player is: "..math.deg(arct) .." degrees")
  end
end
print("Thank you, game over!")


-- Exercise

-- write functions for all menu 1,3