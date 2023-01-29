import std/algorithm
import std/options
import std/sequtils
import std/strformat
import std/terminal

import camera
import color
import hittable
import hittable_list
import material
import ray
import rtweekend
import types
import vec3 


proc getColor(r: Ray, world: HittableList, depth: int): Color =
  if depth <= 0:
    return newColor(0, 0, 0)

  let res = world.hit(r, 0.001, Inf)
  if res.isSome:
    let
      rec = res.get
      (isHit, scattered, attenuation) = rec.material.scatter(r, rec)
    
    if isHit:
      return attenuation * scattered.getColor(world, depth - 1)
    return newColor(0, 0, 0)

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

  let
    world = newHittableList()
    materialGround = newMaterial(newLambertian(newColor(0.8, 0.8, 0.0)))
    materialCenter = newMaterial(newLambertian(newColor(0.1, 0.2, 0.5)))
    materialLeft = newMaterial(newDielectric(1.5))
    materialRight = newMaterial(newMetal(newColor(0.8, 0.6, 0.2), 0.0))

  world.add(newHittable(newSphere(newPoint3(0.0, -100.5, -1.0), 100.0, materialGround)))
  world.add(newHittable(newSphere(newPoint3(0.0, 0.0, -1.0), 0.5, materialCenter)))
  world.add(newHittable(newSphere(newPoint3(-1.0, 0.0, -1.0), 0.5, materialLeft)))
  world.add(newHittable(newSphere(newPoint3(-1.0, 0.0, -1.0), -0.45, materialLeft)))
  world.add(newHittable(newSphere(newPoint3(1.0, 0.0, -1.0), 0.5, materialRight)))

  let
    lookfrom = newPoint3(-2.0, 2.0, 1.0)
    lookat = newPoint3(0.0, 0.0, -1.0)
    vup = newVec3(0.0, 1.0, 0.0)
    distToFocus = (lookfrom - lookat).length
    aperture = 2.0
    camera = newCamera(lookfrom, lookat, vup, 20.0, aspectRatio, aperture, distToFocus)

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
