import std/math
import std/options 

import ray
import types
import vec3


proc setFaceNormal*(self: var HitRecord, r: Ray, outwardNormal: Vec3) =
  self.isFrontFace = (r.direction.dot outwardNormal) < 0
  self.normal =
    if self.isFrontFace: outwardNormal
    else: -outwardNormal

func isFrontFace*(r: Ray, outwardNormal: Vec3): bool =
  (r.direction.dot outwardNormal) < 0

func getFaceNormal*(r: Ray, outwardNormal: Vec3): Vec3 =
  if isFrontFace(r, outwardNormal): outwardNormal
  else: -outwardNormal

proc newHitRecord*(
  p: Point3,
  normal: Vec3,
  material: Material,
  t: float,
  isFrontFace: bool
): HitRecord =
  HitRecord(
    p: p,
    normal: normal,
    material: material,
    t: t,
    isFrontFace: isFrontFace
  )


proc hit*(self: Sphere, r: Ray, tMin, tMax: float): Option[HitRecord] =
  let
    oc = r.origin - self.center
    a = r.direction.lengthSquared
    halfB = oc.toVec.dot r.direction
    c = oc.lengthSquared - self.radius * self.radius

    discriminant = halfB * halfB - a * c

  if discriminant < 0:
    return none(HitRecord)

  let sqrtd = discriminant.sqrt
  var root = (-halfB - sqrtd) / a
  if root < tMin or tMax < root:
    root = (-halfB + sqrtd) / a
    if root < tMin or tMax < root:
      return none(HitRecord)
  
  let
    t = root
    p = r.at(t)
    outwardNormal = (p - self.center).toVec / self.radius
    rec = newHitRecord(
      p,
      getFaceNormal(r, outwardNormal),
      self.material,
      t,
      isFrontFace(r, outwardNormal)
    )

  some(rec)


func newSphere*(center: Point3, radius: float, mat: Material): Sphere =
  Sphere(center: center, radius: radius, material: mat)


proc hit*(self: Hittable, r: Ray, tMin, tMax: float): Option[HitRecord] =
  case self.kind:
  of hkSphere:
    self.sphere.hit(r, tMin, tMax)

func newHittable*[T](hittable: T): Hittable =
  when T is Sphere:
    Hittable(kind: hkSphere, sphere: hittable)
