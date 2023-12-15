import std/strutils
import ../utils


# Create a type of the cubes held
type
  Game = object
    red, green, blue: int
    id: int = -1

proc prod(game: Game): int = game.red * game.blue * game.green

var base = Game(red: 12, green: 13, blue: 14)
echo base

proc parseLine(line: string): seq[Game] =
  let split = line.split(":")
  let id_str = split[0].split()[1]
  var
    red, green, blue: int = 0
    id: int

  # Parse the line
  id = parseInt(id_str)
  # Split the game line
  var games_str = split[1].split(";")
  var games = newSeq[Game](games_str.len)
  for i, game_str in games_str.pairs:
    # Extract data
    let cubes = game_str.strip.split(",")
    for cube in cubes:
      if "red" in cube:
        red = cube.strip.split()[0].parseInt
      elif "blue" in cube:
        blue = cube.strip.split()[0].parseInt
      elif "green" in cube:
        green = cube.strip.split()[0].parseInt
    games[i] = Game(red: red, green: green, blue: blue, id: id)
  return games

# Overwrite the > operator
proc `>`(game1, game2: Game): bool =
  if game1.red > game2.red:
    return true
  if game1.blue > game2.blue:
    return true
  if game1.green > game2.green:
    return true
  false

proc min(games: seq[Game]): Game =
  var
    red, green, blue: int = 0
  for game in games:
    red = max(red, game.red)
    blue = max(blue, game.blue)
    green = max(green, game.green)
  return Game(red: red, green: green, blue: blue, id: games[0].id)
  

var sum1, sum2: int = 0
for line in fileLines("input"):
  let games = parseLine(line)
  var ok: bool = true
  for game in games:
    if game > base:
      ok = false
  if ok:
    sum1 += games[0].id

  # do second part
  let min_game = games.min
  sum2 += min_game.prod

echo "First = " & $sum1
echo "Second = " & $sum2


print_timing()
