import std/random


randomize()


proc randomFloat*(): float =
  rand(1.0)


proc randomFloat*(min, max: float): float =
  rand(min .. max)
  # min + (max - min) * randomFloat()


func clamp*(x, min, max: float): float =
  if x < min: min
  elif x > max: max
  else: x
