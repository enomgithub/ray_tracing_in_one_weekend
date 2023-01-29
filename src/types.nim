import std/options

type
  Vec3* = ref object
    e*: array[3, float]

  Point3* = distinct Vec3

  Color* = distinct Vec3

  Ray* = ref object
    orig*: Point3
    dir*: Vec3
 
  Lambertian* = ref object
    albedo*: Color
  
  Metal* = ref object
    albedo*: Color
    fuzz*: float
  
  Dielectric* = ref object
    ir*: float

  MaterialKind* = enum
    mkLambertian
    mkMetal
    mkDielectric

  Material* = object
    case kind*: MaterialKind
    of mkLambertian:
      lambertian*: Lambertian
    of mkMetal:
      metal*: Metal
    of mkDielectric:
      dielectric*: Dielectric

  HitRecord* = ref object
    p*: Point3
    normal*: Vec3
    material*: Material
    t*: float
    isFrontFace*: bool

  MaterialImpl* = concept
    proc scatter(self: Self, rayIn: Ray, rec: HitRecord): (bool, Ray, Color)
 
  HittableImpl* {.explain.} = concept
    proc hit(self: Self, r: Ray, tMin, tMax: float): Option[HitRecord]

  Sphere* = ref object
    center*: Point3
    radius*: float
    material*: Material
  
  HittableKind* = enum
    hkSphere

  Hittable* = ref object
    case kind*: HittableKind
    of hkSphere:
      sphere*: Sphere

  HittableList* = ref object
    objects*: seq[Hittable]

  Camera* = ref object
    origin*: Point3
    horizontal*: Vec3
    vertical*: Vec3
    lowerLeftCorner*: Vec3
    u*, v*, w*: Vec3
    lensRadius*: float

