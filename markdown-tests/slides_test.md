# A Slideshow with `lookatme`

## Introduction

- The package `lookatme` is a package that renders markdown slides in the command line.
- The language is standard markdown.
- You can include code blocks as well

```julia
using BlackBoxOptim

function rosebrock2d(x)
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

res = bboptimize(rosenbrock2d; SearchRange = (-5.0, 5.0), NumDimensions = 2)
```

---

## A Second Slide

- Enumerated lists as
  1. One
  2. Cow
  3. Goes
  4. For
  5. Milk

---

## Where to find docs

- You can find them [in this GitHub Repo](https://github.com/d0c-s4vage/lookatme)


