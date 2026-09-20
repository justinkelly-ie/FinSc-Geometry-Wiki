# Finitist ChromoCategory QuickCheck Verification Specification

```idris
module Wiki.ChromoCategorySpec

import Data.List
import Core.BoxInt
import Core.VexelMaxel
import Core
import Math.RationalTrig
import Math.ChromoCategory
import Wiki.Generators

%default total
```

## 1. Categorical Composition & Identity Invariants

$$\forall M_1, M_2, M_3 \in \text{Maxel}, \quad (M_3 \circ M_2) \circ M_1 \equiv M_3 \circ (M_2 \circ M_1)$$

```idris
public export
prop_chromoComposeAssociative : Integer -> Integer -> Integer -> Bool
prop_chromoComposeAssociative w1 w2 w3 =
  let m1 = MkMaxel [(MkPixel 1 1, intToBoxInt w1)]
      m2 = MkMaxel [(MkPixel 1 1, intToBoxInt w2)]
      m3 = MkMaxel [(MkPixel 1 1, intToBoxInt w3)]
      lhs = composeChromo (composeChromo m3 m2) m1
      rhs = composeChromo m3 (composeChromo m2 m1)
  in canonicalizeMaxel lhs == canonicalizeMaxel rhs
```

```idris
public export
prop_chromoIdentityLeft : Integer -> Bool
prop_chromoIdentityLeft w =
  let m = MkMaxel [(MkPixel 1 1, intToBoxInt w), (MkPixel 2 2, intToBoxInt (w + 1))]
      res = composeChromo idChromo m
  in canonicalizeMaxel res == canonicalizeMaxel m
```

```idris
public export
prop_chromoIdentityRight : Integer -> Bool
prop_chromoIdentityRight w =
  let m = MkMaxel [(MkPixel 1 1, intToBoxInt w), (MkPixel 2 2, intToBoxInt (w + 1))]
      res = composeChromo m idChromo
  in canonicalizeMaxel res == canonicalizeMaxel m
```

## 2. Metric Quadrance Evaluation Invariants

$$\text{quadranceVexelSpace}(S, v) \equiv \langle v, v \rangle_{g_{\text{color}}}$$

```idris
public export
prop_chromoQuadranceBlue : Integer -> Integer -> Bool
prop_chromoQuadranceBlue x y =
  let v = MkVexel [(MkUnixel 1, intToBoxInt x), (MkUnixel 2, intToBoxInt y)]
      sp = defaultSpace 2 Blue
      q = quadranceVexelSpace sp v
  in q == intToBoxInt (x * x + y * y)
```

```idris
public export
prop_chromoQuadranceRed : Integer -> Integer -> Bool
prop_chromoQuadranceRed x y =
  let v = MkVexel [(MkUnixel 1, intToBoxInt x), (MkUnixel 2, intToBoxInt y)]
      sp = defaultSpace 2 Red
      q = quadranceVexelSpace sp v
  in q == intToBoxInt (x * x - y * y)
```

```idris
public export
prop_chromoQuadranceGreen : Integer -> Integer -> Bool
prop_chromoQuadranceGreen x y =
  let v = MkVexel [(MkUnixel 1, intToBoxInt x), (MkUnixel 2, intToBoxInt y)]
      sp = defaultSpace 2 Green
      q = quadranceVexelSpace sp v
  in q == intToBoxInt (2 * x * y)
```

## 3. QuickCheck & 2LTT Quadrea Path Execution Runner

```idris
public export
auditChromoCategorySpecProof : IO Bool
auditChromoCategorySpecProof = do
  let r1 = qc3 prop_chromoComposeAssociative
  let r2 = qc prop_chromoIdentityLeft
  let r3 = qc prop_chromoIdentityRight
  let r4 = qc2 prop_chromoQuadranceBlue
  let r5 = qc2 prop_chromoQuadranceRed
  let r6 = qc2 prop_chromoQuadranceGreen
  let t6_8_ok = Math.RationalTrig.auditThreeFoldChromogeometryProof
  let twoLTTQuadreaOk = Math.RationalTrig.auditQuadreaArchimedesPathProof
  pure ( r1.pass == Just True 
      && r2.pass == Just True 
      && r3.pass == Just True 
      && r4.pass == Just True 
      && r5.pass == Just True 
      && r6.pass == Just True 
      && t6_8_ok
      && twoLTTQuadreaOk
       )
```
