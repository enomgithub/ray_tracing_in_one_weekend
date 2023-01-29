import std/math

import ray
import rtweekend
import types
import vec3


proc scatter*(self: Lambertian, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  var scatterDirection = rec.normal + randomUnitVector()

  if scatterDirection.nearZero:
    scatterDirection = rec.normal

  let
    scattered = newRay(rec.p, scatterDirection)
    attenuation = self.albedo

  (true, scattered, attenuation)

func newLambertian*(albedo: Color): Lambertian =
  Lambertian(albedo: albedo)


proc scatter*(self: Metal, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  let
    reflected = rayIn.direction.unit.reflect(rec.normal)
    scattered = newRay(rec.p, reflected + self.fuzz * randomInUnitSphere())
    attenuation = self.albedo

  ((scattered.direction.dot rec.normal) > 0, scattered, attenuation)

func newMetal*(albedo: Color, fuzz: float): Metal =
  Metal(albedo: albedo, fuzz: fuzz.clamp(0.0, 1.0))


func reflectance(cosine, refIdx: float): float =
  let
    r0 = (1.0 - refIdx) / (1.0 + refIdx)
    r1 = r0 * r0
  r1 + (1.0 - r1) * pow((1.0 - cosine), 5)

proc scatter*(self: Dielectric, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  let
    attenuation = newColor(1.0, 1.0, 1.0)
    refractionRatio =
      if rec.isFrontFace: (1.0 / self.ir)
      else: self.ir

    unitDirection = rayIn.direction.unit
    cosTheta = min(-unitDirection.dot rec.normal, 1.0)
    sinTheta = sqrt(1.0 - cosTheta * cosTheta)

    cannotRefract = refractionRatio * sinTheta > 1.0

    direction =
      if cannotRefract or reflectance(cosTheta, refractionRatio) > randomFloat():
        unitDirection.reflect(rec.normal)
      else:
        unitDirection.refract(rec.normal, refractionRatio)

    scattered = newRay(rec.p, direction)

  (true, scattered, attenuation)

func newDielectric*(ir: float): Dielectric =
  Dielectric(ir: ir)


proc scatter*(self: Material, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  case self.kind:
  of mkLambertian:
    self.lambertian.scatter(rayIn, rec)
  of mkMetal:
    self.metal.scatter(rayIn, rec)
  of mkDielectric:
    self.dielectric.scatter(rayIn, rec)

func newMaterial*[T](material: T): Material =
  when T is Lambertian:
    Material(kind: mkLambertian, lambertian: material)
  elif T is Metal:
    Material(kind: mkMetal, metal: material)
  elif T is Dielectric:
    Material(kind: mkDielectric, dielectric: material)
