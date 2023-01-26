import ray
import vec3


type
  Camera* = ref object
    aspectRatio*: float
    viewportHeight*: float
    viewportWidth*: float
    focalLength*: float

    origin*: Point3
    horizontal*: Vec3
    vertical*: Vec3
    lowerLeftCorner*: Vec3


func newCamera*(): Camera =
  const
    aspectRatio = 16.0 / 9.0
    viewportHeight = 2.0
    viewportWidth = aspectRatio * viewportHeight
    focalLength = 1.0

  let
    origin = newPoint3(0, 0, 0)
    horizontal = newVec3(viewportWidth, 0.0, 0.0)
    vertical = newVec3(0.0, viewportHeight, 0.0)
    lowerLeftCorner = origin.toVec - horizontal / 2 - vertical / 2 - newVec3(0, 0, focalLength)

  Camera(
    aspectRatio: aspectRatio,
    viewportHeight: viewportHeight,
    viewportWidth: viewportWidth,
    focalLength: focalLength,
    origin: origin,
    horizontal: horizontal,
    vertical: vertical,
    lowerLeftCorner: lowerLeftCorner
  )


func getRay*(self: Camera, u, v: float): Ray =
  newRay(
    self.origin,
    self.lowerLeftCorner + u * self.horizontal + v * self.vertical - self.origin.toVec
  )
