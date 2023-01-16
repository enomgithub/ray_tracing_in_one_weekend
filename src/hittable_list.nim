import hittable
import ray


type
  HittableList* {.explain.} = concept x
    x is Hittable
    x.clear is proc(self: HittableList)
    x.add is proc(self: HittableList, obj: Hittable)
    x.objects is seq[Hittable]


func hit(self: HittableList, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
  var
    tempRec: HitRecord
    hitAnything = false
    closestSoFar = tMax
  
  for obj in self.objects:
    if obj.hit(r, tMin, closestSoFar, tempRec):
      hitAnything = true
      closestSoFar = tempRec.t
      rec = tempRec
  
  hitAnything


proc clear(self: HittableList) =
  self.objects = @[]


proc add(self: HittableList, obj: Hittable) =
  self.objects.add(obj)


func newHittableList*(objects: seq[Hittable]): HittableList =
  HittableList(
    objects: objects,
    hit: proc(self: HittableList, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
      self.hit(r, tMin, tMax, rec),
    clear: proc(self: HittableList) = self.clear(),
    add: proc(self: HittableList, obj: Hittable) = self.add(obj)
  )
