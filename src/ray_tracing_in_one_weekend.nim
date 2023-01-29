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


proc randomScene(): HittableList =
  let
    world = newHittableList()
    groundMaterial = newMaterial(newLambertian(newColor(0.5, 0.5, 0.5)))
  
  world.add(newHittable(newSphere(newPoint3(0.0, -1000.0, 0.0), 1000.0, groundMaterial)))

  for a in -11..<11:
    for b in -11..<11:
      let
        chooseMat = randomFloat()
        center = newPoint3(a.float + 0.9 * randomFloat(), 0.2, b.float + 0.9 * randomFloat())

      if (center - newPoint3(4.0, 0.2, 0.0)).length > 0.9:
        let sphereMaterial =
          if chooseMat < 0.8:
            let albedo = random().toColor
            newMaterial(newLambertian(albedo))
          elif chooseMat < 0.95:
            let
              albedo = random().toColor
              fuzz = randomFloat(0.0, 0.5)
            newMaterial(newMetal(albedo, fuzz))
          else:
            newMaterial(newDielectric(1.5))
        
        world.add(newHittable(newSphere(center, 0.2, sphereMaterial)))
  
  let
    material1 = newMaterial(newDielectric(1.5))
    material2 = newMaterial(newLambertian(newColor(0.4, 0.2, 0.1)))
    material3 = newMaterial(newMetal(newColor(0.7, 0.6, 0.5), 0.0))

  world.add(newHittable(newSphere(newPoint3(0.0, 1.0, 0.0), 1.0, material1)))
  world.add(newHittable(newSphere(newPoint3(-4.0, 1.0, 0.0), 1.0, material2)))
  world.add(newHittable(newSphere(newPoint3(4.0, 1.0, 0.0), 1.0, material3)))

  world


proc main(): cint =
  const
    aspectRatio = 3.0 / 2.0
    imageWidth = 1200
    imageHeight = (imageWidth / aspectRatio).int
    samplesPerPixel = 500
    maxDepth = 50

  let
    world = randomScene()

    lookfrom = newPoint3(13.0, 2.0, 3.0)
    lookat = newPoint3(0.0, 0.0, 0.0)
    vup = newVec3(0.0, 1.0, 0.0)
    distToFocus = 10.0
    aperture = 0.1
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
