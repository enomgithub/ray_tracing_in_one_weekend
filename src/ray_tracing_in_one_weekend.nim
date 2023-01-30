import std/algorithm
import std/options
import std/os
import std/sequtils
import std/strformat
import std/strutils
import std/terminal
import std/threadpool

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
  var world = newHittableList()
  let groundMaterial = newMaterial(newLambertian(newColor(0.5, 0.5, 0.5)))
  
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


proc getImage(
  world: HittableList,
  camera: Camera,
  n: int,
  imageWidth, imageHeight, samplesPerPixel, maxDepth: int
): seq[seq[RGBColor]] =
  stderr.styledWriteLine(fmt"thread {n} started")

  var image: seq[seq[RGBColor]] = @[]
  for j in 0..<imageHeight:
    image.add(@[])
    for i in 0..<imageWidth:
      image[j].add(newRGBColor())

  for j in (0..<imageHeight).toSeq.reversed:
    for i in 0..<imageWidth:
      var pixelColor = newColor(0, 0, 0)
      for s in 0..<samplesPerPixel:
        let
          u = (i.float + randomFloat()) / (imageWidth - 1).float
          v = (j.float + randomFloat()) / (imageHeight - 1).float
          ray = camera.getRay(u, v)
        pixelColor += ray.getColor(world, maxDepth)
      image[imageHeight - 1 - j][i] = pixelColor.getRGB(samplesPerPixel)

  stderr.styledWriteLine(fmt"thread {n} finished")
  image


func mergeImages(
  imageWidth, imageHeight, thread: static int,
  images: seq[seq[seq[RGBColor]]]
): seq[seq[RGBColor]] =
  var image: seq[seq[RGBColor]] = @[]
  for j in 0..<imageHeight:
    image.add(@[])
    for i in 0..<imageWidth:
      image[j].add(newRGBColor())

  for j in (0..<imageHeight):
    for i in 0..<imageWidth:
      var rgb = newRGBColor()
      for k in 0..<thread:
        rgb += images[k][j][i]
      image[j][i] = rgb / thread
  image


proc writeImage(
  imageWidth, imageHeight: int,
  image: seq[seq[RGBColor]],
  outputFilePath: string
) =
  var
    fp = outputFilePath.open(mode = fmWrite)
    texts: seq[string] = @[]

  texts.add("P3")
  texts.add(fmt"{imageWidth} {imageHeight}")
  texts.add("255")
  for j in (0..<imageHeight):
    stderr.styledWriteLine(fgRed, "Scanlines remaining: ", resetStyle, fmt"{j}")
    for i in 0..<imageWidth:
      texts.add($image[j][i])
    stderr.cursorUp(1)
    stderr.eraseLine

  fp.write(texts.join("\n"))
  stderr.styledWriteLine(fgRed, "Done")


proc main(): cint =
  const
    aspectRatio = 3.0 / 2.0
    imageWidth = 1200
    imageHeight = (imageWidth / aspectRatio).int
    thread = 20
    samplesPerPixel = 500 div thread
    maxDepth = 50

  let
    world = randomScene()

    lookfrom = newPoint3(13.0, 2.0, 3.0)
    lookat = newPoint3(0.0, 0.0, 0.0)
    vup = newVec3(0.0, 1.0, 0.0)
    distToFocus = 10.0
    aperture = 0.1
    camera = newCamera(lookfrom, lookat, vup, 20.0, aspectRatio, aperture, distToFocus)

  var tasks: seq[FlowVar[seq[seq[RGBColor]]]] = @[]

  for n in 0..<thread:
    let task = spawn getImage(world, camera, n, imageWidth, imageHeight, samplesPerPixel, maxDepth)
    tasks.add(task)

  sync()

  var images: seq[seq[seq[RGBColor]]] = @[]
  for n in 0..<thread:
    images.add(^tasks[n])

  let
    mergedImage = mergeImages(imageWidth, imageHeight, thread, images)
    outputFilePath = absolutePath(joinPath(getCurrentDir(), "image.ppm"))

  writeImage(imageWidth, imageHeight, mergedImage, outputFilePath)

  0


when isMainModule:
  quit(main())
