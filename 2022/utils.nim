
iterator fileLines*(file: File): string =
  var line: string
  while file.readLine(line):
    yield line

iterator fileLines*(file: string): string =
  var fh: File
  if fh.open(file):
    for line in fh.fileLines:
      yield line

func reduce*[T](arr: openarray[T]): T =
  for a in arr:
    result += a
  return result

