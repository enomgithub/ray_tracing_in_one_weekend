import std/math
import std/strformat


type
  Vec3* = ref object
    e: array[3, float]

  Point3* = distinct Vec3


func newVec3*(x, y, z: float): Vec3 =
  Vec3(e: [x, y, z])

func `[]`*(self: Vec3, i: int): float =
  self.e[i]

func x*(self: Vec3): float =
  self[0]

func y*(self: Vec3): float =
  self[1]

func z*(self: Vec3): float =
  self[2]

func `$`*(self: Vec3): string =
  fmt"{self.x} {self.y} {self.z}"

func `-`*(self: Vec3): Vec3 =
  newVec3(-self.x, -self.y, -self.z)

func `+`*(self, vec: Vec3): Vec3 =
  newVec3(self.x + vec.x, self.y + vec.y, self.z + vec.z)

func `-`*(self, vec: Vec3): Vec3 =
  newVec3(self.x - vec.x, self.y - vec.y, self.z - vec.z)

func `*`*(self, vec: Vec3): Vec3 =
  newVec3(self.x * vec.x, self.y * vec.y, self.z * vec.z)

func `*`*(self: Vec3, scalar: float): Vec3 =
  newVec3(self.x * scalar, self.y * scalar, self.z * scalar)

func `*`*(scalar: float, vec: Vec3): Vec3 =
  vec * scalar

func `/`*(self: Vec3, scalar: float): Vec3 =
  self * (1 / scalar)

func `dot`*(self, vec: Vec3): float =
  self.x * vec.x + self.y * vec.y + self.z * vec.z

func `cross`*(self, vec: Vec3): Vec3 =
  newVec3(
    self.y * vec.z - self.z * vec.y,
    self.z * vec.x - self.x * vec.z,
    self.x * vec.y - self.y * vec.x
  )

func `+=`*(self: var Vec3, vec: Vec3) =
  self.e[0] += vec.e[0]
  self.e[1] += vec.e[1]
  self.e[2] += vec.e[2]

func `*=`*(self: var Vec3, scalar: float) =
  self.e[0] *= scalar
  self.e[1] *= scalar
  self.e[2] *= scalar

func `/=`*(self: var Vec3, scalar: float) =
  self *= 1 / scalar

func lengthSquared*(self: Vec3): float =
  self.x * self.x + self.y * self.y + self.z * self.z

func length*(self: Vec3): float =
  self.lengthSquared().sqrt()

func unit*(self: Vec3): Vec3 =
  self / self.length

func toPoint*(self: Vec3): Point3 =
  self.Point3


func newPoint3*(x, y, z: float): Point3 =
  newVec3(x, y, z).Point3

func `[]`*(self: Point3, i: int): float {.borrow.}
func x*(self: Point3): float {.borrow.}
func y*(self: Point3): float {.borrow.}
func z*(self: Point3): float {.borrow.}
func `-`*(self: Point3): Point3 {.borrow.}
func `+`*(self, point: Point3): Point3 {.borrow.}
func `-`*(self, point: Point3): Point3 {.borrow.}
func `*`*(self, point: Point3): Point3 {.borrow.}
func `*`*(self: Point3, scalar: float): Point3 {.borrow.}
func `*`*(scalar: float, point: Point3): Point3 {.borrow.}
func `/`*(self: Point3, scalar: float): Point3 {.borrow.}
func `dot`*(self, point: Point3): float {.borrow.}
func `cross`*(self, point: Point3): Point3 {.borrow.}
func `+=`*(self: var Point3, point: Point3) {.borrow.}
func `*=`*(self: var Point3, scalar: float) {.borrow.}
func `/=`*(self: var Point3, scalar: float) {.borrow.}
func lengthSquared*(self: Point3): float {.borrow.}
func length*(self: Point3): float {.borrow.}
func unit*(self: Point3): Point3 {.borrow.}

func toVec*(self: Point3): Vec3 =
  self.Vec3
