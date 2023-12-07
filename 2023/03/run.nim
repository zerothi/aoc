import std/re
import std/sugar
import std/strutils
import std/deques
import ../readfile


type
  Line = object
    line: string
    # digits located
    bounds: seq[(int, int)]
    # digits located
    symbols: seq[int]


# Create an iterator looping a regular exp
# on a file returning all matches
iterator findAllBounds(line: string, re: Regex): (int, int) =
  var cur = line.findBounds(re)
  while cur[0] > -1:
    yield cur
    cur = line.findBounds(re, cur[1] + 1)

proc parseLine(line: string): Line =
  result = Line(line: line)
  let number = re"\d+"
  let symbol = re"[^\d\.]"
  result.bounds = collect(newSeq):
    for bound in line.findAllBounds(number):
      bound
  result.symbols = collect(newSeq):
    for bound in line.findAllBounds(symbol):
      bound[0]
  return result

# this could have been a template, but in this case it is the same
# since there is nothing that prevents it from running (const debug, for instance)
proc overlapping(bound: (int, int), i: int): bool =
  let
    l: int = bound[0]
    h: int = bound[1]
  if l - 1 <= i and i <= h + 1:
    return true
  false

iterator loopBounds(lines: Deque[Line]): (Line, (int, int)) =
  for line in lines:
    for bound in line.bounds:
      yield (line, bound)

iterator loopSymbols(lines: Deque[Line]): int =
  for line in lines:
    for idx in line.symbols:
      yield idx

iterator loopSymbols(line: Line): int =
  for idx in line.symbols:
    yield idx

proc sumOverlaps(lines: Deque[Line], line: Line): int =
  result = 0
  for bound in line.bounds:
    for idx in lines.loopSymbols:
      if bound.overlapping(idx):
        result += line.line[bound[0]..bound[1]].parseInt
        break
  return result

proc prodOverlaps(lines: Deque[Line], line: Line): int =
  result = 0
  var
    overlaps, partial: int

  for idx in line.loopSymbols:

    # check for correct symbol
    if line.line[idx] != '*':
      continue

    partial = 0
    overlaps = 0
    for lineb, bound in lines.loopBounds:
      if bound.overlapping(idx):
        inc overlaps
        if overlaps == 1:
          partial = lineb.line[bound[0]..bound[1]].parseInt
        elif overlaps == 2:
          partial *= lineb.line[bound[0]..bound[1]].parseInt
        else:
          echo "too many"
          partial = 0
          break
    
    if overlaps == 2:
      result += partial

  return result


# Read the file
var sum1, sum2: int = 0
var lines: Deque[Line] = initDeque[Line](3)

for line in fileLines("input"):
  if lines.len == 3:
    # pop before we add the nex line
    discard lines.popFirst

  lines.addLast(parseLine(line))

  case lines.len:
    of 2:
      sum1 += lines.sumOverlaps(lines[0])
      sum2 += lines.prodOverlaps(lines[0])
    of 3:
      sum1 += lines.sumOverlaps(lines[1])
      sum2 += lines.prodOverlaps(lines[1])
    else:
      discard
      
# Last line needs to be added
discard lines.popFirst
assert lines.len == 2
sum1 += lines.sumOverlaps(lines[1])
sum2 += lines.prodOverlaps(lines[1])

echo "First " & $sum1
echo "Second " & $sum2
