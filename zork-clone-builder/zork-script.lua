zork.SetName("Example")

while true do
    command = zork.GetCommand()

    print(table.concat(command, ", "))
end
