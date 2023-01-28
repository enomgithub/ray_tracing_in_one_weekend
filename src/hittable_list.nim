import std/options

import hittable
import types


func hit*(self: HittableList, r: Ray, tMin: float, tMax: float): Option[HitRecord] =
  var
    rec = new HitRecord
    hitAnything = false
    closestSoFar = tMax
  
  for obj in self.objects:
    let res = obj.hit(r, tMin, closestSoFar)
    if res.isSome:
      hitAnything = true
      let tempRec = res.get
      closestSoFar = tempRec.t
      rec = tempRec

  if hitAnything: some(rec)
  else: none(HitRecord)


proc clear*(self: HittableList) =
  self.objects = @[]


proc add*(self: HittableList, obj: Hittable) =
  self.objects.add(obj)


func newHittableList*(objects: seq[Hittable] = @[]): HittableList =
  HittableList(objects: objects)
