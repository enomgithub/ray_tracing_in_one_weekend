import std/math

import hittable
import ray
import vec3


type
  Sphere* {.explain.} = concept x
    x is Hittable
    x.center is Point3
    x.radius is float


proc hit(self: Sphere, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
  let
    oc = r.origin - self.center
    a = r.direction.lengthSquared
    halfB = oc.toVec.dot r.direction
    c = oc.lengthSquared - self.radius * self.radius

    discriminant = halfB * halfB - a * c

  if discriminant < 0:
    return false

  let sqrtd = discriminant.sqrt
  var root = (-halfB - sqrtd) / a
  if root < tMin or tMax < root:
    root = (-halfB + sqrtd) / a
    if root < tMin or tMax < root:
      return false
  
  rec.t = root
  rec.p = r.at(rec.t)
  let outwardNormal = (rec.p - self.center).toVec / self.radius
  rec.setFaceNormal(r, outwardNormal)

  true


func newSphere*(center: Point3, radius: float): Sphere =
  Sphere(
    center: center,
    radius: radius,
    hit: proc(self: Sphere, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
      self.hit(r, tMin, tMax, rec)
  )