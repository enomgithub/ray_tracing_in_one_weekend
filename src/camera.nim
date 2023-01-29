import std/math

import ray
import types
import vec3


func newCamera*(lookfrom, lookat: Point3, vup: Vec3, vfov, aspectRatio: float): Camera =
  let
    theta = vfov.degToRad
    h = tan(theta / 2.0)
    viewportHeight = 2.0 * h
    viewportWidth = aspectRatio * viewportHeight

    w = (lookfrom - lookat).unit
    u = (vup.cross w.toVec).unit
    v = w.toVec.cross u

  const
    focalLength = 1.0

  let
    origin = lookfrom
    horizontal = viewportWidth * u
    vertical = viewportHeight * v
    lowerLeftCorner = origin.toVec - horizontal / 2 - vertical / 2 - w.toVec

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


func getRay*(self: Camera, s, t: float): Ray =
  newRay(
    self.origin,
    self.lowerLeftCorner + s * self.horizontal + t * self.vertical - self.origin.toVec
  )
