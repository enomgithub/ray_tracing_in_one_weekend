import ray
import vec3


type
  HitRecord* = ref object
    p*: Point3
    normal*: Vec3
    t*: float
    isFrontFace*: bool

  Hittable* {.explain.} = concept
    proc hit(self: Self, r: Ray, tMin, tMax: float, rec: var HitRecord): bool


proc setFaceNormal*(self: var HitRecord, r: Ray, outwardNormal: Vec3) =
  self.isFrontFace = (r.direction.dot outwardNormal) < 0
  self.normal =
    if self.isFrontFace: outwardNormal
    else: -outwardNormal


proc newHitRecord*(p: Point3, normal: Vec3, t: float, isFrontFace: bool): HitRecord =
  HitRecord(
    p: p,
    normal: normal,
    t: t,
    isFrontFace: isFrontFace
  )
