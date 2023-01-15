import ray
import vec3


type
  HitRecord* = ref object of RootObj
    p*: Point3
    normal*: Vec3
    t*: float
    isFrontFace: bool


proc setFaceNormal*(self: var HitRecord, r: Ray, outwardNormal: Vec3) =
  self.isFrontFace = (r.direction.dot outwardNormal) < 0
  self.normal =
    if self.isFrontFace: outwardNormal
    else: -outwardNormal
  