import std/algorithm
import std/sequtils
import std/strformat
import std/terminal


proc main(): cint =
  const
    imageWidth = 256
    imageHeight = 256

  echo "P3"
  echo fmt"{imageWidth} {imageHeight}"
  echo "255"
  for j in (0..<imageHeight).toSeq().reversed():
    stderr.styledWriteLine(fgRed, "Scanlines remaining: ", resetStyle, fmt"{j}")
    for i in 0..<imageWidth:
      let
        r = i.float / (imageWidth - 1)
        g = j.float / (imageHeight - 1)
        b = 0.25

        ir = (255.999 * r).int
        ig = (255.999 * g).int
        ib = (255.999 * b).int

      echo fmt"{ir} {ig} {ib}"

    stderr.cursorUp(1)
    stderr.eraseLine()
  
  stderr.styledWriteLine(fgRed, "Done")

  0


when isMainModule:
  quit(main())
