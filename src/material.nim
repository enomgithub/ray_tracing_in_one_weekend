import ray
import types
import vec3


proc scatter*(self: Lambertian, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  var scatterDirection = rec.normal + randomUnitVector()

  if scatterDirection.nearZero:
    scatterDirection = rec.normal

  let
    scattered = newRay(rec.p, scatterDirection)
    attenuation = self.albedo

  (true, scattered, attenuation)

func newLambertian*(albedo: Color): Lambertian =
  Lambertian(albedo: albedo)


func scatter*(self: Metal, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  let
    reflected = rayIn.direction.unit.reflect(rec.normal)
    scattered = newRay(rec.p, reflected)
    attenuation = self.albedo

  ((scattered.direction.dot rec.normal) > 0, scattered, attenuation)

func newMetal*(albedo: Color): Metal =
  Metal(albedo: albedo)


proc scatter*(self: Material, rayIn: Ray, rec: HitRecord): (bool, Ray, Color) =
  case self.kind:
  of mkLambertian:
    self.lambertian.scatter(rayIn, rec)
  of mkMetal:
    self.metal.scatter(rayIn, rec)

func newMaterial*[T](material: T): Material =
  when T is Lambertian:
    Material(kind: mkLambertian, lambertian: material)
  elif T is Metal:
    Material(kind: mkMetal, metal: material)
