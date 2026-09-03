-- Attributes

placeTitle = ""
tokens = 0
lives = 1
moves = 0

-- Place Functions

placedTokens = 1
gotRiverToken = false
gotPlatformToken = false

invalidDirectionSaying = "That would be an odd direction to take so no."

function MainFieldWest(command)
    if #command == 0 then
        placeTitle = "The Main Field"

        zork.Output(placeTitle)
        zork.Output("You stand in a place of endless crop.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("You walk over too a river, splitting the landscape of fields.") return RiverMiddle
        elseif command[2] == "south"    then zork.Output("You fall straight into a hedgerow.\nBrambles and rose encapsulate  you...") lives = 0 return nil
        elseif command[2] == "west"     then zork.Output("There is a hedgerow that direction.") return nil
        elseif command[2] == "east"     then zork.Output("To the east side you walk.") return MainFieldEast
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function MainFieldEast(command)
    if #command == 0 then
        placeTitle = "The Main Field"

        zork.Output(placeTitle)
        zork.Output("You stand in a place of endless crop.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("The fields part to reveal a small bridge running over a river.")  return RuggedBridge
        elseif command[2] == "south"    then zork.Output("You walk back towards the forest.") return ForestEdge
        elseif command[2] == "west"     then zork.Output("To the west side you walk.") return MainFieldWest
        elseif command[2] == "east"     then zork.Output("There is a sinkhole that direction.\nAnd you tragically fall in.") lives = 0 return nil
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end

function GrassyClearing(command)
    if #command == 0 then
        placeTitle = "Grassy Clearing"

        zork.Output(placeTitle)
        zork.Output("A large token sits in the middle of this clearing.")
        zork.Output("You attempt to pick it up.")
        zork.Output("You fail, realising you must bring all other tokens back too this place...")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output(invalidDirectionSaying) return nil
        elseif command[2] == "south"    then zork.Output("Back onto the bridge you walk.") return RuggedBridge
        elseif command[2] == "west"     then zork.Output(invalidDirectionSaying) return nil
        elseif command[2] == "east"     then zork.Output(invalidDirectionSaying) return nil
        else zork.Output(invalidDirectionSaying) end
    elseif command[2] == "tokens" then
        zork.Output("One at a time with tokens.")
    elseif command[2] == "token" then
        if command[1] == "place" or command[1] == "drop" then
            if tokens > 0 then
                zork.Output("You place a token down by the larger token.")
                placedTokens = placedTokens + 1
            else
                zork.Output("You have no tokens so find them first.")
            end
        else
            zork.Output("What are you saying to do with the token?")
        end
    end

    if placedTokens == 3 then
        tokens = 3
    end

    return nil
end

function RuggedBridge(command)
    if #command == 0 then
        placeTitle = "Rugged Bridge"

        zork.Output(placeTitle)
        zork.Output("The bridge seems sturdy so you stay and admire the view of vast fields around you while you ponder the strange position the river sits.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("Off the bridge you walk.") return GrassyClearing
        elseif command[2] == "south"    then zork.Output("Back into fields you tread.") return MainFieldEast
        elseif command[2] == "west"     then zork.Output("You fall off the bridge into a lump of dense stone...") lives = 0 return nil
        elseif command[2] == "east"     then zork.Output("You fall off the bridge into a lump of dense stone...") lives = 0 return nil
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end

function RiverMiddle(command)
    if #command == 0 then
        placeTitle = "River"

        zork.Output(placeTitle)
        zork.Output("Looking over the expanse of the river that seems too run through a field you sit over the edge of the path.")
        zork.Output("To the east there is a small truss bridge linking the fields.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("You fall into the river smashing your bones on a loose, jagged rock...") lives = 0 return nil
        elseif command[2] == "south"    then return MainFieldWest
        elseif command[2] == "west"     then zork.Output("Along the river edge you walk.") return RiverWestIsh
        elseif command[2] == "east"     then zork.Output("Up onto the rugged bridge climb...") return RuggedBridge
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function RiverWestIsh(command)
    if #command == 0 then
        placeTitle = "River"

        zork.Output(placeTitle)
        zork.Output("You sit calmly with a river flowing west infront.")
        if ~gotRiverTokenToken then
            zork.Output("You see a shimmering item infront of you, just in the rocks of the river.")
        end
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("The tide of the river catches you offgard...\n You flow off the edge of the cliff to the west, down a waterfall and into the deep azure plunge pool where you are washed up on the shore by the sea.") return WaterfallBySea
        elseif command[2] == "south"    then return WestFieldMiddle
        elseif command[2] == "west"     then zork.Output("Up a gently sloping hill you walk while curving south west.") return WestFieldTop
        elseif command[2] == "east"     then zork.Output("Along the river edge you walk.") return RiverMiddle
        else zork.Output(invalidDirectionSaying) end
    elseif command[2] == "item" then
        if command[1] == "pickup" or command[1] == "collect" or command[1] == "get" or command[1] == "investigate" then
            if ~gotRiverTokenToken then
                zork.Output("You realise the shimmer of the item was the sign of a token.")
                zork.Output("You have obtained a token.")
                tokens = tokens + 1
            else
                zork.Output("Why would there be a token here now?")
            end
        else
            zork.Output("What are you saying to do with the item?")
        end
    end

    return nil
end

function OceanDrown(command)
    placeTitle = "Ocean"

    zork.Output(placeTitle)
    zork.Output("You get swept by the tide of the sea, taking you far out into a void of pale blue.")
    zork.Output("You drown all alone.")
    lives = 0

    return nil
end

function RockyPlatform(command)
    if #command == 0 then
        placeTitle = "Rocky Platform"

        zork.Output(placeTitle)
        zork.Output("You stand above the sea on a rocky outer edge, over the sea.")
        if ~gotPlatformToken then
            zork.Output("One item on the rocks stands out as unique as it shimmers in the sunlight.")
        end
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("Why would you walk off a plaform into a choppy ocean?") return OceanDrown
        elseif command[2] == "south"    then zork.Output("Back into the cove you walk.") return WaterfallBySea
        elseif command[2] == "west"     then zork.Output("Into the ocean you go") return OceanDrown
        elseif command[2] == "east"     then zork.Output("I repeat why would you walk off a plaform into a choppy ocean?") return OceanDrown
        else zork.Output(invalidDirectionSaying) end
    elseif command[2] == "item" then
        if command[1] == "pickup" or command[1] == "collect" or command[1] == "get" or command[1] == "investigate" then
            if ~gotPlatformToken then
                zork.Output("You realise the shimmer of the item was the sign of a token.")
                zork.Output("You have obtained a token.")
                tokens = tokens + 1
            else
                zork.Output("Why would there be a token here now?")
            end
        else
            zork.Output("What are you saying to do with the item?")
        end
    end

    return nil
end
function WaterfallBySea(command)
    if #command == 0 then
        placeTitle = "Waterfall Cove"

        zork.Output(placeTitle)
        zork.Output("A waterfall trickles into the ocean beyond you.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("This seems almost different.") return RockyPlatform
        elseif command[2] == "south"    then zork.Output("Back along and along the beach you walk.") return NorthBeach
        elseif command[2] == "west"     then zork.Output("Into the ocean you go") return OceanDrown
        elseif command[2] == "east"     then zork.Output("Into the waterfall you fall... forever.") lives = 0 return nil
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function NorthBeach(command)
    if #command == 0 then
        placeTitle = "Beach"

        zork.Output(placeTitle)
        zork.Output("Just more beach, and more beach, awaits.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("On and on you go.") return WaterfallBySea
        elseif command[2] == "south"    then zork.Output("Back along the beach you walk.") return SouthBeach
        elseif command[2] == "west"     then zork.Output("Into the ocean you go") return OceanDrown
        elseif command[2] == "east"     then zork.Output("A cliff face meets you that way so no.") return nil
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function SouthBeach(command)
    if #command == 0 then
        placeTitle = "Beach"

        zork.Output(placeTitle)
        zork.Output("You now sit stretched out along a beach while the waves crash down infront of you.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("Along the beach you walk.") return NorthBeach
        elseif command[2] == "south"    then zork.Output("An outstretch of ocean meets you.") return OceanDrown
        elseif command[2] == "west"     then zork.Output("Into the ocean you go") return OceanDrown
        elseif command[2] == "east"     then zork.Output("Back up the steep dirt path you walk.") return CliffEdgePath
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function CliffEdgePath(command)
    if #command == 0 then
        placeTitle = "Cliff Edge Path"

        zork.Output(placeTitle)
        zork.Output("You stop for a moment on the edge of the cliff path overlooking a vast ocean of shimmering beauty.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("You follow the dirt path all the way down the cliff face, twisting and turning...") return SouthBeach
        elseif command[2] == "south"    then return CliffEdgeFall
        elseif command[2] == "west"     then return CliffEdgeFall
        elseif command[2] == "east"     then zork.Output("Back through long grass you walk the dirt path.") return WestFieldMiddle
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function CliffEdgeFall(command)
    placeTitle = "Cliff Edge"

    zork.Output(placeTitle)
    zork.Output("The ground disapears beneath your feet while you walk the wrong direction...")
    zork.Output("You have fallen off a steep cliff to a fatal rocky fall while a view of ocean and vivid sky expands in front of your eyes.")
    lives = 0

    return nil
end

function WestFieldTop(command)
    if #command == 0 then
        placeTitle = "West Field"

        zork.Output(placeTitle)
        zork.Output("This is the top end of a thin sliver of a field in the west.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("The ground gently slopes as you curve north east.") return RiverWestIsh
        elseif command[2] == "south"    then return WestFieldMiddle
        elseif command[2] == "west"     then zork.Output("You enter long grass in a flury as you find a path running along the edge of a vast cliff-face.") zork.Output("However, you don't pay attention to the slope onto the path, losing your footing as the edge turns into a vicious fall.") lives = 0 return nil
        elseif command[2] == "east"     then zork.Output("This hedgerow is still to the east.") return ForestEdge
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function WestFieldMiddle(command)
    if #command == 0 then
        placeTitle = "West Field"

        zork.Output(placeTitle)
        zork.Output("This is the middle of a thin sliver of a field in the west.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then return WestFieldTop
        elseif command[2] == "south"    then return WestField
        elseif command[2] == "west"     then zork.Output("A dirt path extends through long grass up too a cliffs edge...") return CliffEdgePath
        elseif command[2] == "east"     then zork.Output("This hedgerow is still to the east.") return nil
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end
function WestField(command)
    if #command == 0 then
        placeTitle = "West Field"

        zork.Output(placeTitle)
        zork.Output("This is a thin sliver of a field in the west.")
    end

    if command[1] == "go" then
        if command[2] == "north"        then return WestFieldMiddle
        elseif command[2] == "south"    then zork.Output("Dense forest blocks your southern route.") return nil
        elseif command[2] == "west"     then zork.Output("Entering long grass you tread carefully.") return CliffEdgeFall
        elseif command[2] == "east"     then zork.Output("You walk through a gap in a hedgerow...") return ForestEdge
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end

function LostForest(command)
    placeTitle = "Lost Forest"

    zork.Output(placeTitle)
    zork.Output("South is where you carry on.")
    zork.Output("This forest seems to go on forever?")
    zork.Output("You get desperate and take a left...")
    zork.Output("Which way was north again?")
    zork.Output("Right you go.\nThen left.\nRetracing your steps you go backwards.\nWas that right?\nNo its right again isn't it......")

    zork.Output("\nYou never find your way out.")
    lives = 0
    
    return nil
end

function ForestEdge(command)
    if #command == 0 then -- Entered Place
        placeTitle = "Forest Edge"

        zork.Output(placeTitle)
        zork.Output("You are on the edge of a dense forest, to the south, while north stretches a vast, abandoned landscape.")
        zork.Output("Find the 3 tokens to escape, without passing away...")
    end

    if command[1] == "go" then
        if command[2] == "north"        then zork.Output("You walk away from the forest.") return MainFieldEast
        elseif command[2] == "south"    then zork.Output("You enter the forest...") return LostForest
        elseif command[2] == "west"     then zork.Output("You walk through a gap in a hedgerow...") return WestField
        elseif command[2] == "east"     then zork.Output("A closed pine farm gate blocks this way from your access.") return nil
        else zork.Output(invalidDirectionSaying) end
    end

    return nil
end

-- Runtime

command = {}

function RunZork()
    placedTokens = 1
    gotRiverToken = false
    gotPlatformToken = false

    placeTitle = ""
    tokens = 0
    lives = 1
    moves = 0

    zork.SetName("Example")
    zork.SetAttributes({ { "Place", placeTitle }, { "Tokens", tostring(tokens) }, { "Lives", tostring(lives) }, { "Moves", tostring(moves) } })

    zork.Output("Welcome, to ZORK!")

    local place = ForestEdge

    while true do
        local potentialPlace = place(command)

        if potentialPlace ~= nil then
            place = potentialPlace
            place({})
        end

        zork.SetAttributes({ { "Place", placeTitle }, { "Tokens", tostring(tokens) }, { "Lives", tostring(lives) }, { "Moves", tostring(moves) } })

        if lives == 0 then
            zork.Output("You only have one life to live and you wasted it.")
            return
        elseif tokens == 3 then
            zork.Output("Wow you managed to escape.")
            zork.Output("You are free.")
            return
        end


        command = zork.GetCommand()
        moves = moves + 1
        print(table.concat(command, ", "))
    end
end

while command[1] ~= "n" do
    RunZork()

    zork.Output("\nWould you care to try again? (Y/n)")

    command = zork.GetCommand()
end
