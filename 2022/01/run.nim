import std/[strutils, algorithm]
import ../utils

var
  max1, itmp: int = 0
  maxD: array[3, int]
  inserted: int = 0

for line in fileLines("input"):
  
  if line.strip().len == 0:
    max1 = max(max1, itmp)
    if inserted < 3:
      maxD[inserted] = itmp
      inc inserted
      if inserted == 3:
        maxD.sort()
    else:
      for i, a in maxD:
        if a <= itmp:
          for j in 0..<i:
            maxD[j] = maxD[j+1]
          maxD[i] = itmp
    itmp = 0
  else:
    itmp += line.strip().parseInt

max1 = max(max1, itmp)
echo "First = ", max1

echo maxD[0] + maxD[1] + maxD[2]
