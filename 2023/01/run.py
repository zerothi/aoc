
def calibration1(lines):
    def isint(s):
        try:
            int(s)
            return True
        except:
            return False
    def calibrate(line):
        ints = [i for i in line if isint(i)]
        return int(ints[0] + ints[-1])
    return sum(map(calibrate, lines))

import re
def calibration2(lines):
    def isint(s):
        try:
            int(s)
            return True
        except:
            return False
    numbers = "one two three four five six seven eight nine".split()
    number = re.compile('(' + '|'.join(numbers) + ')')
    def calibrate(line):
        line = line.strip()
        if not line:
            return 0

        start = 0
        match = number.search(line[start:])
        while match:
            start = start + match.start(0)
            line = line[:start] + str(numbers.index(match.group(0)) + 1) + line[start+1:]
            match = number.search(line[start:]) 

        ints = [i for i in line if isint(i)]
        return int(ints[0] + ints[-1])
    return sum(map(calibrate, lines))


lines = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet""".splitlines()
print("Example calibration [1] line:")
print(calibration1(lines) == 142)


lines = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen""".splitlines()
print("Example calibration [2] line:")
print(calibration2(lines) == 281)


print("Calibration (1, 2) value:")
lines = open("input", 'r').readlines()
print(calibration1(lines))
print(calibration2(lines))
