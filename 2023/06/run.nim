import std/algorithm
import std/strutils
import std/sequtils
import std/sugar


iterator fileLines(file: File): string =
  var line: string
  while file.readLine(line):
    yield line

iterator fileLines(file: string): string =
  var fh: File
  if fh.open(file):
    for line in fh.fileLines:
      yield line

# Read the file
var
  times: seq[int]
  dists: seq[int]
for line in fileLines("input"):

  if line.startsWith("Time"):
    times = line.split(":")[1].split().filter(x => x.len > 0).map(x => x.parseInt)
  if line.startsWith("Distance"):
    dists = line.split(":")[1].split().filter(x => x.len > 0).map(x => x.parseInt)


iterator distanceTravelled(tot_time: int): int =
  for pressed in 1..<tot_time:
    yield pressed * (tot_time - pressed) 


var val1: int = 1
for td in zip(times, dists):
  let
    time = td[0]
    dist = td[1]
  echo "time = " & $time
  var count: int = 0

  for myd in distanceTravelled(time):
    if myd > dist:
      inc count
  val1 *= count

echo "First = " & $val1

let time = times.map(x => x.intToStr).join("").parseInt
let dist = dists.map(x => x.intToStr).join("").parseInt
var
  val2: int = 0
for myd in distanceTravelled(time):
  if myd > dist:
    inc val2
echo "Second = " & $val2
