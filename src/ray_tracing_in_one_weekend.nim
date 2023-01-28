import std/algorithm
import std/sequtils
import std/strformat
import std/terminal

import camera
import color
import hittable
import hittable_list
import ray
import rtweekend
import sphere
import vec3 


proc getColor(r: Ray, world: HittableList, depth: int): Color =
  if depth <= 0:
    return newColor(0, 0, 0)

  var rec: HitRecord
  if world.hit(r, 0.001, Inf, rec):
    let target = rec.p + rec.normal.toPoint + randomUnitVector().toPoint
    return 0.5 * newRay(rec.p, target.toVec - rec.p.toVec).getColor(world, depth - 1)

  let
    unitDirection = r.direction.unit
    t = 0.5 * (unitDirection.y + 1.0)

  (1.0 - t) * newColor(1.0, 1.0, 1.0) + t * newColor(0.5, 0.7, 1.0)


proc main(): cint =
  const
    aspectRatio = 16.0 / 9.0
    imageWidth = 400
    imageHeight = (imageWidth / aspectRatio).int
    samplesPerPixel = 100
    maxDepth = 50

  let world = newHittableList[Sphere]()
  world.add(newSphere(newPoint3(0, 0, -1), 0.5))
  world.add(newSphere(newPoint3(0, -100.5, -1), 100))

  let camera = newCamera()

  echo "P3"
  echo fmt"{imageWidth} {imageHeight}"
  echo "255"
  for j in (0..<imageHeight).toSeq.reversed:
    stderr.styledWriteLine(fgRed, "Scanlines remaining: ", resetStyle, fmt"{j}")
    for i in 0..<imageWidth:
      var pixelColor = newColor(0, 0, 0)
      for s in 0..<samplesPerPixel:
        let
          u = (i.float + randomFloat()) / (imageWidth - 1)
          v = (j.float + randomFloat()) / (imageHeight - 1)
          ray = camera.getRay(u, v)
        pixelColor += ray.getColor(world, maxDepth)

      stdout.writeColor(pixelColor, samplesPerPixel)

    stderr.cursorUp(1)
    stderr.eraseLine
  
  stderr.styledWriteLine(fgRed, "Done")

  0


when isMainModule:
  quit(main())
