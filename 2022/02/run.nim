import std/[sequtils, strutils]
import ../utils

const
  O = @['A', 'B', 'C']
  M = @['X', 'Y', 'Z']


var
  sum1, sum2: int = 0


for line in fileLines("input"):
  let
    om = line.split()
    o = O.find(om[0][0])
    m = M.find(om[1][0])

  if m == o:
    # draw
    sum1 += m + 1 + 3
  elif (m + 2) mod 3 == o:
    # win
    sum1 += m + 1 + 6
  else:
    sum1 += m + 1

  if m == 0:
    # loose
    sum2 += (o + 2) mod 3 + 1
  elif m == 1:
    # draw
    sum2 += o + 1 + 3
  else:
    # win
    sum2 += (o + 1) mod 3 + 1 + 6

echo "First = ", sum1
echo "Second = ", sum2
    

  
