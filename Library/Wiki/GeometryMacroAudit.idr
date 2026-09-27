module Wiki.GeometryMacroAudit

import Stage1.InformationGeometry
import Stage1.GrassmannCalculus
import Language.Reflection

%default total

%inline public export
auditWitness : (target : Bool) -> Elab (target = True)
auditWitness True = pure Refl
auditWitness False = fail "Geometry macro audit check failed: proof export returned False"

%inline public export
allTrue : List Bool -> Bool
allTrue [] = True
allTrue (True :: xs) = allTrue xs
allTrue (False :: _) = False

%inline public export
auditCatalogWitnesses : (targets : List Bool) -> Elab (allTrue targets = True)
auditCatalogWitnesses targets = auditWitness (allTrue targets)

public export
auditHyperbolicBitDualityProofExport : Bool
auditHyperbolicBitDualityProofExport = Stage1.InformationGeometry.auditHyperbolicBitDualityProof

public export
%macro
auditHyperbolicBitDuality : Elab (Wiki.GeometryMacroAudit.auditHyperbolicBitDualityProofExport = True)
auditHyperbolicBitDuality = auditWitness auditHyperbolicBitDualityProofExport

public export
auditCliffordCompactnessDualityProofExport : Bool
auditCliffordCompactnessDualityProofExport = Stage1.InformationGeometry.auditCliffordCompactnessDualityProof

public export
%macro
auditCliffordCompactnessDuality : Elab (Wiki.GeometryMacroAudit.auditCliffordCompactnessDualityProofExport = True)
auditCliffordCompactnessDuality = auditWitness auditCliffordCompactnessDualityProofExport

public export
auditHolographicBoundaryDualityProofExport : Bool
auditHolographicBoundaryDualityProofExport = Stage1.InformationGeometry.auditHolographicBoundaryDualityProof

public export
%macro
auditHolographicBoundaryDuality : Elab (Wiki.GeometryMacroAudit.auditHolographicBoundaryDualityProofExport = True)
auditHolographicBoundaryDuality = auditWitness auditHolographicBoundaryDualityProofExport

public export
geometryMacroWitnesses : List Bool
geometryMacroWitnesses =
  [ auditHyperbolicBitDualityProofExport
  , auditCliffordCompactnessDualityProofExport
  , auditHolographicBoundaryDualityProofExport
  ]

public export
%macro
auditGeometryMacroCatalog : Elab (allTrue Wiki.GeometryMacroAudit.geometryMacroWitnesses = True)
auditGeometryMacroCatalog = auditCatalogWitnesses geometryMacroWitnesses
