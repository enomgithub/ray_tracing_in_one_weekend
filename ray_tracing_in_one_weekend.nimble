# Package

version       = "0.1.0"
author        = "Satoshi Enomoto"
description   = "Ray Tracing in One Weekend"
license       = "MIT"
srcDir        = "src"
bin           = @["ray_tracing_in_one_weekend"]


# Dependencies

requires "nim >= 1.6.8"


# Tasks

task release, "release build":
  let command = "nimble build -d:release --mm:orc --threads:on"
  exec(command)
