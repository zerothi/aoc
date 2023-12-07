import std/strutils
import std/algorithm
import std/sequtils
import std/sugar
import ../utils

type
  HandType = enum
    High
    Pair1
    Pair2
    Three
    House
    Four
    Five

  Bid = object
    hand: string
    bid: int
    typ: int
  
let CardType1 = @[
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'J',
  'Q',
  'K',
  'A',
]

var bids: seq[Bid]

func getUniqs(bid: Bid): seq[(int, char)] =
  var i = 0
  var hand = bid.hand
  while hand.len > 0:
    let c = hand[0]
    result.add((hand.count(c), c))
    inc i
    hand = hand.replace(c, ' ').strip
  return result

for line in fileLines("input"):
  let ls = line.strip().split()
  var bid = Bid(hand: ls[0], bid: ls[1].parseInt)

  # get type, then we can sort by rank
  let uniqs = getUniqs(bid).unzip()[0]

  if 5 in uniqs:
    bid.typ = HandType.Five.ord
  elif 4 in uniqs:
    bid.typ = HandType.Four.ord
  elif 3 in uniqs and 2 in uniqs:
    bid.typ = HandType.House.ord
  elif 3 in uniqs:
    bid.typ = HandType.Three.ord
  elif uniqs.count(2) == 2:
    bid.typ = HandType.Pair2.ord
  elif 2 in uniqs:
    bid.typ = HandType.Pair1.ord
  else:
    bid.typ = HandType.High.ord

  bids.add(bid)


proc ct1(c: char): int = CardType1.find(c)
let CardType2 = @[
  'J',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'T',
  'Q',
  'K',
  'A',
]
proc ct2(c: char): int = CardType2.find(c)

proc hsort1(x, y: Bid): int =
  if x.typ > y.typ: 1
  elif y.typ > x.typ: -1
  else:
    # Last case
    for i in 0..<x.hand.len:
      if ct1(x.hand[i]) > ct1(y.hand[i]):
        return 1
      elif ct1(x.hand[i]) < ct1(y.hand[i]):
        return -1
    return 0

proc hsort2(x, y: Bid): int =
  if x.typ > y.typ: 1
  elif y.typ > x.typ: -1
  else:
    # Last case
    for i in 0..<x.hand.len:
      if ct2(x.hand[i]) > ct2(y.hand[i]):
        return 1
      elif ct2(x.hand[i]) < ct2(y.hand[i]):
        return -1
    return 0


bids.sort(hsort1)
var sum1 = 0
for i, bid in bids:
  sum1 += (i+1) * bid.bid
echo "First = ", sum1

# Now fix all the hands such that the J's maximize the hand
proc usort(x, y: (int, char)): int =
  if x[0] > y[0]: 1
  elif x[0] < y[0]: -1
  else:
    0
proc happly(b: var Bid) =
  if 'J' in b.hand:
    let uniqs = getUniqs(b)
    var nJs = collect:
      for cc in uniqs:
        if cc[1] != 'J': cc
    let J = collect:
      for cc in uniqs:
        if cc[1] == 'J': cc
    let Js = J[0][0]

    nJs.sort(usort, SortOrder.Descending)

    if nJs.len == 0:
      b.typ = HandType.Five.ord
    elif nJs[0][0] + Js == 5:
      b.typ = HandType.Five.ord
    elif nJs[0][0] + Js == 4:
      b.typ = HandType.Four.ord
    elif nJs.len > 1:
      if nJs[0][0] + nJs[1][0] + Js == 5:
        b.typ = HandType.House.ord
      elif nJs[0][0] + Js == 3:
        b.typ = HandType.Three.ord
      elif nJs[0][0] + nJs[1][0] + Js == 4:
        b.typ = HandType.Pair2.ord
      elif nJs[0][0] + Js == 2:
        b.typ = HandType.Pair1.ord
    elif nJs[0][0] + Js == 3:
      b.typ = HandType.Three.ord
    elif nJs[0][0] + Js == 2:
      b.typ = HandType.Pair1.ord

bids.apply(happly)
bids.sort(hsort2)

var sum2 = 0
for i, bid in bids:
  sum2 += (i+1) * bid.bid
echo "Second = ", sum2


