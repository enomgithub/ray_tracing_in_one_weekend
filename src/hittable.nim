import ray
import vec3


type
  HitRecord* {.explain.} = concept x
    x.p is Point3
    x.normal is Vec3
    x.t is float
    x.isFrontFace is bool
    x.setFaceNormal is proc(self: var typeof x, r: Ray, outwardNormal: Vec3)

  Hittable* {.explain.} = concept x
    x.hit is proc(self: typeof x, r: Ray, tMin, tMax: float, rec: var HitRecord): bool


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
    isFrontFace: isFrontFace,
    setFaceNormal: proc(self: var HitRecord, r: Ray, outwardNormal: Vec3) =
      self.setFaceNormal(r, outwardNormal)
  )
