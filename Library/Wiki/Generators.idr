module Wiki.Generators

import public QuickCheck
import Geometry.LatticeTopology
import Math.LinAlgebra.TernaryClassifier
import Core.BoxInt

%default total

public export
natToTernary : Nat -> TernaryBit
natToTernary Z = Bit3MinusOne
natToTernary (S Z) = Bit3Zero
natToTernary (S (S _)) = Bit3PlusOne

public export
Arbitrary TernaryBit where
  arbitrary = map natToTernary arbitrary

  coarbitrary Bit3MinusOne gen = coarbitrary (the Nat 0) gen
  coarbitrary Bit3Zero gen     = coarbitrary (the Nat 1) gen
  coarbitrary Bit3PlusOne gen  = coarbitrary (the Nat 2) gen

public export
Arbitrary Coord3D where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    pure (MkCoord3D x y z)

  coarbitrary (MkCoord3D x y z) gen =
    coarbitrary x (coarbitrary y (coarbitrary z gen))

public export
qc : (Arbitrary a, Show a, Testable prop) => (a -> prop) -> QCRes
qc f = quickCheck (MkFn f)

public export
qc2 : (Arbitrary a, Show a, Arbitrary b, Show b, Testable prop) => (a -> b -> prop) -> QCRes
qc2 f = quickCheck (MkFn (\x => MkFn (f x)))

public export
qc3 : (Arbitrary a, Show a, Arbitrary b, Show b, Arbitrary c, Show c, Testable prop) => (a -> b -> c -> prop) -> QCRes
qc3 f = quickCheck (MkFn (\x => MkFn (\y => MkFn (f x y))))
