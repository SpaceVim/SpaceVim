match command.split():
# ^ conditional
    case ["quit"]:
    # ^ conditional
        print("Goodbye!")
        quit_game()
    case ["look"]:
    # ^ conditional
        current_room.describe()
    case ["get", obj]:
    # ^ conditional
        character.get(obj, current_room)
    case ["go", direction]:
    # ^ conditional
        current_room = current_room.neighbor(direction)
    # The rest of your commands go here

match command.split():
# ^ conditional
    case ["drop", *objects]:
    # ^ conditional
        for obj in objects:
            character.drop(obj, current_room)

match command.split():
# ^ conditional
    case ["quit"]: ... # Code omitted for brevity
    case ["go", direction]: pass
    case ["drop", *objects]: pass
    case _:
        print(f"Sorry, I couldn't understand {command!r}")

match command.split():
# ^ conditional
    case ["north"] | ["go", "north"]:
    # ^ conditional
        current_room = current_room.neighbor("north")
    case ["get", obj] | ["pick", "up", obj] | ["pick", obj, "up"]:
    # ^ conditional
        pass

match = 2
#   ^ variable
match, a = 2, 3
#   ^ variable
match: int = secret
#   ^ variable
x, match: str = 2, "hey, what's up?"
# <- variable
#   ^ variable
