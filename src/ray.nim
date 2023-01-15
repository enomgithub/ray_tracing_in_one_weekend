import vec3


type Ray* = ref object
  orig: Point3
  dir: Vec3

func newRay*(origin: Point3, direction: Vec3): Ray =
  Ray(orig: origin, dir: direction)

func origin*(self: Ray): Point3 =
  self.orig

func direction*(self: Ray): Vec3 =
  self.dir

func at*(self: Ray, t: float): Point3 =
  self.orig + t * self.dir.toPoint
