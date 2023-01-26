import hittable
import ray
import sphere


type
  HittableList* = ref object
    # hit: proc(self: HittableList, r: Ray, tMin, tMax: float, rec: var HitRecord): bool
    # clear: proc(self: HittableList)
    # add: proc(self: HittableList, obj: T)
    objects: seq[Sphere]


func hit*(self: HittableList, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
  var
    tempRec = new HitRecord
    hitAnything = false
    closestSoFar = tMax
  
  for obj in self.objects:
    if obj.hit(r, tMin, closestSoFar, tempRec):
      hitAnything = true
      closestSoFar = tempRec.t
      rec = tempRec
  
  hitAnything


proc clear*(self: HittableList) =
  self.objects = @[]


proc add*(self: HittableList, obj: Sphere) =
  self.objects.add(obj)


func newHittableList*(objects: seq[Sphere] = @[]): HittableList =
  HittableList(
    objects: objects,
    # hit: proc(self: HittableList, r: Ray, tMin, tMax: float, rec: var HitRecord): bool =
    #   self.hit(r, tMin, tMax, rec),
    # clear: proc(self: HittableList) = self.clear(),
    # add: proc(self: HittableList, obj: T) = self.add(obj)
  )
