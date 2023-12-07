import std/algorithm
import std/math
import std/deques
import std/sequtils
import std/strutils
import ../utils

const sortInt = system.cmp[int]

# Yield lists of values separated by |
proc asLists(line: string): (seq[int], seq[int]) =
  let idx_colon = line.find(':')
  let win_drawn = line[(idx_colon + 1) ..< line.len].replace("  ", " ").split('|')
  let left = win_drawn[0].strip().split().map(proc(x: string): int = x.parseInt)
  let right = win_drawn[1].strip().split().map(proc(x: string): int = x.parseInt)
  return (left, right.sorted(sortInt))

proc wins(a, b: seq[int]): int =
  result = 0
  for i in a:
    if b.binarySearch(i) >= 0:
      inc result
  return result

proc points(a, b: seq[int]): int =
  2 ^ wins(a, b) div 2

# Read the file
var sum1, sum2, sum3: int = 0

# expect roughly 10 simultaneous wins
var countWins: seq[int] = newSeqWith(10, 0) 

for line in fileLines("input"):
  # convert to lists
  let win_mine = asLists(line)

  # determine how many cards we won
  let win_n = wins(win_mine[0], win_mine[1])

  # Calculate points on card
  let points = 2 ^ win_n div 2
  sum1 += points
  let copies = 1 + countWins[0]
  inc sum2, copies
  sum3 += points * copies
  countWins[0] = 0
  countWins.rotateLeft(1)

  for i in 0..<win_n:
    inc countWins[i], copies

echo "First " & $sum1
echo "Second " & $sum2
echo "(total winning points) " & $sum3
