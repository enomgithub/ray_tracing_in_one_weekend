import vec3


type
  HitRecord* = ref object of RootObj
    p*: Point3
    normal*: Vec3
    t*: float
  