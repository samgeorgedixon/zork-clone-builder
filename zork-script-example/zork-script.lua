-- Attributes

placeTitle = ""
score = 0
lives = 5
moves = 0

attributes = { { "Place", placeTitle }, { "Score", tostring(score) }, { "Lives", tostring(lives) }, { "Moves", tostring(moves) } }

-- Place Functions

function Test(command)
    if #command == 0 then -- Entered Place
        placeTitle = "TEST"

        zork.Output("TEST")
        zork.Output("You are a test.")
    end

    return nil
end
 
function ForestEdge(command)
    if #command == 0 then -- Entered Place
        placeTitle = "Forest Edge"

        zork.Output("Forest Edge")
        zork.Output("You are on the edge of a dense forest being to your right while on your left stretches a vast landscape of fields.")
    end

    if command[1] == "go" then             
        if command[2] == "north" then   return Test
        else zork.Output("That would be an odd direction to take so no.") end
    end

    return nil
end

-- Runtime

zork.SetName("Example")
zork.SetAttributes(attributes)

zork.Output("Welcome, to ZORK!")

command = {}
place = ForestEdge

while true do
    local potentialPlace = place(command)

    if potentialPlace ~= nil then
        place = potentialPlace
        place({})
    end

    zork.SetAttributes(attributes)

    command = zork.GetCommand()
    moves = moves + 1
    print(table.concat(command, ", "))
end
