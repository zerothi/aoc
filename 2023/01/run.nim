import std/sugar
import std/strutils
import std/re
import ../readfile


proc isint(s: string): bool =
  try:
    discard parseInt(s)
    result = true
  except:
    result = false

proc isInt(s: char): bool = isInt($s)

proc calibration1(lines: openArray[string]): int = 
  ## First calibration method of day 1
  ## Loop over all lines, and return the characters that can
  ## be parsed to integers.
  ## Then the first + last parseable characters gets merged and
  ## converted to an int.

  proc getCalibration(s: string): int =
    let list = collect:
      for c in s:
        if c.isDigit:
          c
    return parseInt(list[0] & list[list.high])
  
  var sum: int = 0
  for line in lines:
    sum += getCalibration(line)
  sum
  
proc calibration2(lines: openArray[string]): int = 
  ## First calibration method of day 1
  ## Loop over all lines, and return the characters that can
  ## be parsed to integers.
  ## Then the first + last parseable characters gets merged and
  ## converted to an int.
  let numbers: seq[string] = "one two three four five six seven eight nine".split()

  let number = re("(" & numbers.join("|") & ")")

  proc getCalibration(s: string): int =
    let list = collect:
      for c in s:
        if isInt(c):
          c
    if list.len == 0: return 0
    return parseInt(list[0] & list[list.high])
  
  var sum: int = 0
  for line in lines:
    # Create a new copy with the stuff replaced
    var dine = line

    block:
      var idx: int = 0
      var cur = line.findBounds(number, idx)
      while cur[0] > -1:
        let I = numbers.find(line[cur[0]..cur[1]])
        #echo "found " & $I & " from " & line[cur[0]..cur[1]]
        dine[cur[0]..cur[0]] = $(I + 1)
        idx = cur[0] + 1
        cur = line.findBounds(number, idx)
        
    sum += getCalibration(dine)
  sum


var lines = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet""".split()

echo "Example calibration [1] line:"
echo calibration1(lines) == 142


lines = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen""".split()
echo "Example calibration [2] line:"
echo calibration2(lines) == 281


echo "Calibration (1, 2) value:"
lines = collect:
  for line in fileLines("input"):
    line
echo calibration1(lines)
echo calibration2(lines)
