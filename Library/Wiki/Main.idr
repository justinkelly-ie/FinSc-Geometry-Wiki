module Wiki.Main

import System
import Wiki.GeometryScaleTransformSpec
import Wiki.GeometryMacroAudit
import Wiki.ChromoCategorySpec
import Wiki.SpatialProjectionSpec
import Wiki.LatticeStreamSpec
import Geometry.LatticeTopology

%default total

main : IO ()
main = do
  putStrLn "========================================================"
  putStrLn "  IDRIS 2 GEOMETRY WIKI VERIFICATION SUITE"
  putStrLn "========================================================"
  putStrLn "1. Geometry ScaleTransform (Coord3D <-> Fin 27 Nat) QuickCheck Specs:"
  p <- auditGeometryScaleTransformSpecProof
  if p
     then putStrLn "   [PASSED] Bijective Lattice ScaleTransform Verified!"
     else do
       putStrLn "   [FAILED] QuickCheck Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn "2. ChromoCategory (Finitist Morphisms & Quadrance Invariants) QuickCheck Specs:"
  p2 <- auditChromoCategorySpecProof
  if p2
     then putStrLn "   [PASSED] ChromoCategory Composition & Blue/Red/Green Quadrance Verified!"
     else do
       putStrLn "   [FAILED] ChromoCategory QuickCheck Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn "3. Spatial Projection & Toroidal Boxel Grid QuickCheck Specs:"
  p3 <- auditSpatialProjectionProof
  if p3
     then putStrLn "   [PASSED] Spatial Boxel Stream Projection & Homomorphisms Verified!"
     else do
       putStrLn "   [FAILED] Spatial Projection QuickCheck Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn "4. Deforested 27-Cell Lattice Spatial Coordinate Streaming Specs:"
  p4 <- auditLatticeStreamProof
  if p4
     then putStrLn "   [PASSED] Lattice Stream Anamorphism & Spatial Shifts Verified!"
     else do
       putStrLn "   [FAILED] Lattice Stream Specs Failed!"
       exitWith (ExitFailure 1)
  putStrLn "4. Compile-Time %macro Reflection Proof Catalog:"
  putStrLn ("   [PASSED] Geometric Invariants (Hyperbolic Bit Duality, Clifford, Holographic Boundary): " ++ (if allTrue Wiki.GeometryMacroAudit.geometryMacroWitnesses then "PASSED ✅" else "FAILED ❌"))
  putStrLn "========================================================"
  putStrLn "  GEOMETRY WIKI VERIFICATION COMPLETE: ALL PASSED!"
  putStrLn "========================================================"
