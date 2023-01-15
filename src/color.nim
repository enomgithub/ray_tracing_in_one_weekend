import std/strformat
import std/terminal

import vec3


type Color* = distinct Vec3

func newColor*(x, y, z: float): Color =
  newVec3(x, y, z).Color

func `[]`*(self: Color, i: int): float {.borrow.}
func x(self: Color): float {.borrow.}
func y(self: Color): float {.borrow.}
func z(self: Color): float {.borrow.}

func r*(self: Color): float =
  self.x

func g*(self: Color): float =
  self.y

func b*(self: Color): float =
  self.z

func `-`*(self: Color): Color {.borrow.}
func `+`*(self, color: Color): Color {.borrow.}
func `-`*(self, color: Color): Color {.borrow.}
func `*`*(self, color: Color): Color {.borrow.}
func `*`*(self: Color, scalar: float): Color {.borrow.}
func `*`*(scalar: float, color: Color): Color {.borrow.}
func `/`*(self: Color, scalar: float): Color {.borrow.}
func `dot`*(self, color: Color): float {.borrow.}
func `cross`*(self, color: Color): Color {.borrow.}
func `+=`*(self: var Color, color: Color) {.borrow.}
func `*=`*(self: var Color, scalar: float) {.borrow.}
func `/=`*(self: var Color, scalar: float) {.borrow.}
func lengthSquared*(self: Color): float {.borrow.}
func length*(self: Color): float {.borrow.}
func unit*(self: Color): Color {.borrow.}

proc writeColor*(stream: File, pixelColor: Color) =
  let
    r = (255.999 * pixelColor.r).int
    g = (255.999 * pixelColor.g).int
    b = (255.999 * pixelColor.b).int
  stream.styledWriteLine(fmt"{r} {g} {b}")
