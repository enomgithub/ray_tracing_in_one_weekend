import std/math

import ray
import types
import vec3


func newCamera*(
  lookfrom, lookat: Point3,
  vup: Vec3,
  vfov, aspectRatio, aperture, focusDist: float
): Camera =
  let
    theta = vfov.degToRad
    h = tan(theta / 2.0)
    viewportHeight = 2.0 * h
    viewportWidth = aspectRatio * viewportHeight

    w = (lookfrom - lookat).toVec.unit
    u = (vup.cross w).unit
    v = w.cross u

    origin = lookfrom
    horizontal = focusDist * viewportWidth * u
    vertical = focusDist * viewportHeight * v
    lowerLeftCorner = origin.toVec - horizontal / 2 - vertical / 2 - focusDist * w

    lensRadius = aperture / 2.0

  Camera(
    origin: origin,
    lowerLeftCorner: lowerLeftCorner,
    horizontal: horizontal,
    vertical: vertical,
    u: u,
    v: v,
    w: w,
    lensRadius: lensRadius
  )


proc getRay*(self: Camera, s, t: float): Ray =
  let
    rd = self.lensRadius * randomInUnitDisk()
    offset = self.u * rd.x + self.v * rd.y
  newRay(
    self.origin + offset.toPoint,
    self.lowerLeftCorner + s * self.horizontal + t * self.vertical - self.origin.toVec - offset
  )
