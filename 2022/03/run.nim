import std/[sets, enumerate, deques]
import ../utils


type
  TSet = (HashSet[char], HashSet[char], HashSet[char])
var
  sum1, sum2: int = 0
  group: array[3, TSet]

func priority(cord: int): int =
  if 'a'.ord <= cord and cord <= 'z'.ord:
    return cord - 'a'.ord + 1
  elif 'A'.ord <= cord and cord <= 'Z'.ord:
    return cord - 'A'.ord + 27
  return 0
  

for i, line in enumerate(fileLines("input")):
  let
    left = line[0..<line.len div 2]
    lH = left.toHashSet
    right = line[line.len div 2..<line.len]
    rH = right.toHashSet
    inter = lH * rH
  assert left.len == right.len

  for c in inter:
    sum1 += priority(c.ord)

  group[i mod 3] = (lH, rH, lH + rH)

  if i mod 3 == 2:
    var common: HashSet[char] = group[0][2] * group[1][2] * group[2][2]
  
    assert common.len <= 1
    if common.len == 1:
      sum2 += priority(common.pop.ord) 

echo "First = ", sum1
echo "Second = ", sum2

