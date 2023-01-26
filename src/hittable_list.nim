import hittable
import ray
import sphere


type
  HittableList*[Hittable] = ref object
    objects: seq[Hittable]


func hit*[T: Hittable](
  self: HittableList[T],
  r: Ray,
  tMin: float,
  tMax: float,
  rec: var HitRecord
): bool =
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


proc clear*[T: Hittable](self: HittableList[T]) =
  self.objects = @[]


proc add*[T: Hittable](self: HittableList[T], obj: T) =
  self.objects.add(obj)


func newHittableList*[T: Hittable](objects: seq[T] = @[]): HittableList[T] =
  HittableList[T](objects: objects)
