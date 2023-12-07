import std/strutils
import std/algorithm
import std/sequtils
import std/sugar
import std/deques


iterator fileLines(file: File): string =
  var line: string
  while file.readLine(line):
    yield line

iterator fileLines(file: string): string =
  var fh: File
  if fh.open(file):
    for line in fh.fileLines:
      yield line

type
  Range = object
    start, length: int = 0
  Map = object
    destination, source, length: int
  Maps = object
    list: seq[Map]

  Almanac = object
    list: seq[Maps]

func len(rng: Range): int = rng.length
func End(rng: Range): int = rng.start + rng.length
func len(map: Map): int = map.length
func End(map: Map): int = map.source + map.length

func len(maps: Maps): int = maps.list.len
func len(almanac: Almanac): int = almanac.list.len

# Easier additions of Maps and Map
#func add(maps: Maps, map: Map) =
#  (maps.list).add(map)

func getOverlapping(map: Map, source: Range): Range =
  var
    start, length: int
  
  if map.source < source.End and
    source.start < map.End:
    # Add the overlap region
    start = max(map.source, source.start)
    length = min(map.End, source.End) - start
    result.start = map.destination + start - map.source
    result.length = length
  else:
    result.length = 0
  return result

func getNonOverlapping(map: Map, source: Range): seq[Range] =

  var
    rng: Range
    start, length: int
    missing: int = source.len
  
  # we have something before
  start = source.start
  length = min(source.End, map.source) - start
  if length > 0:
    rng = Range(start: start, length: length)
    result.add(rng)
    dec missing, length

  if missing == 0:
    return result
  
  start = max(map.End, source.start) 
  length = source.End - start
  if length > 0:
    rng = Range(start: start, length: length)
    result.add(rng)
    dec missing, length

  # this is when we have everything returned the same
  return result

proc getDestination(maps: Maps, source: Range): seq[Range] =
  var missing: Deque[Range] = initDeque[Range](10)
  var n: int
  missing.addLast(source)
  for map in maps.list:
    let n_missing = missing.len
    echo "running map with " & $n_missing & " ranges"
    # Only loop that many times
    for i in 1..n_missing:

      let rng = missing.popFirst
      let over = map.getOverlapping(rng)
      n = over.len
      if over.len > 0:
        echo "found overlapping " & $over.len & " / " & $rng.len & " elements"
        result.add(over)
      
      for r in map.getNonOverlapping(rng):
        missing.addLast(r)
        inc n, r.len
      assert n == rng.len

  for rng in missing:
    result.add(rng)
  return result
  

func getDestination(map: Map, source: int): int =
  let dindex = source - map.source
  return map.destination + dindex

func sourceIn(map: Map, source: int): bool =
  map.source <= source and source < map.source + map.length

func getDestination(maps: Maps, source: int): int =
  for map in maps.list:
    if map.sourceIn(source):
      return map.getDestination(source)
  return source
  

func getDestination(almanac: Almanac, seed: int): int =
  result = seed
  for maps in almanac.list:
    result = maps.getDestination(result)
  return result

proc getDestination(almanac: Almanac, seed: Range): seq[Range] =
  var
    next: seq[Range]
  result.add(seed)
  for maps in almanac.list:
    next = collect(newSeq):
      for rngr in result:
        for rng in maps.getDestination(rngr):
          rng

    # clean so we can re-populate it
    result = @[]
    for rng in next:
      result.add(rng)
    next = @[]
  return result

# TODO learn templates to do the below collect single line

var
  seeds: seq[int]
  map: Map = Map()
  maps: Maps
  almanac: Almanac = Almanac()

# Read the file
for line in fileLines("input"):
  if line.len < 2:
    continue

  if ':' in line:
    # a specification
    let specs = line.split(":")
    if specs[0] == "seeds":
      seeds = collect:
        for el in specs[1].strip().split():
          el.parseInt
    else:
      if maps.len > 0:
        almanac.list.add(maps)
      # it must be a specification
      maps = Maps()

  else:
    let vals = collect:
      for v in line.split():
        v.parseInt
    map = Map(destination: vals[0],
              source: vals[1],
              length: vals[2])
    maps.list.add(map)

almanac.list.add(maps)

var soils = collect:
  for seed in seeds:
    almanac.getDestination(seed)

soils.sort
echo "First = " & $soils[0]


iterator loopRange(seeds: seq[int]): Range =
  var idx = 0
  while idx + 1 < seeds.len:
    yield Range(start: seeds[idx], length: seeds[idx+1])
    inc idx, 2

iterator loopSeeds(rng: Range): int =
  let start = rng.start - 1
  for i in 1..rng.length:
    yield start + i

echo "Seeds = "
echo seeds


# The actual problem was that seeds is a range
# onvert the seeds to a range
var val2: int = high(int)
for rng in loopRange(seeds):
  let rngs = almanac.getDestination(rng)
  for rng_dest in rngs:
    val2 = min(val2, rng_dest.start)

echo "Second = " & $val2
