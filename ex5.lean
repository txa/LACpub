/-
COMP2012 (LAC) 2026

Exercise 5

Construct a CFG and PDA for the language of bracket-matched
words.

Don't change anything else in this file!
-/
import Proofs.CFG
import Mathlib.Tactic.DeriveFintype
import Proofs.PDA

namespace ex5

open Lang Sum Cfg CFG Pda PDA

/-
Let SigmaPar be the alphabet of left and right brackets
-/

inductive SigmaPar : Type
| lpar -- "⟨"
| rpar -- "⟩"
deriving Fintype, DecidableEq
open SigmaPar

/- 1. Define a CFG for the language -/
inductive NTPar : Type
| S
deriving Fintype, DecidableEq
open NTPar

abbrev GPar : CFG SigmaPar
:= { NT := NTPar
     S := NTPar.S
     P := {
        (NTPar.S, []),                                                  -- S -> ε
        (NTPar.S, [Sum.inl NTPar.S, Sum.inl NTPar.S]),                  -- S -> S S
        (NTPar.S, [Sum.inr lpar, Sum.inl NTPar.S, Sum.inr rpar])        -- S -> ⟨ S ⟩
     }
}

/- 2. Define a PDA for the language -/
inductive QPar : Type
| q0 -- reading state
| qf -- final accepting state
deriving Fintype, DecidableEq
open QPar

inductive ΓPar : Type
| Z -- initial bottom-of-stack symbol
| X -- bracket counter
deriving Fintype, DecidableEq
open ΓPar

abbrev PPar : PDA SigmaPar
:= { Q := QPar
     Γ := ΓPar
     s := q0
     Z₀ := Z
     F := {qf}
     δ := fun q x z => match q, x, z with
          -- Push 'X' for every left bracket
          | q0, some lpar, Z => {(q0, [X, Z])}
          | q0, some lpar, X => {(q0, [X, X])}
          -- Pop 'X' for every right bracket
          | q0, some rpar, X => {(q0, [])}
          -- If the stack is empty of X's, epsilon-transition to the final state
          | q0, none, Z => {(qf, [Z])}
          -- All other transitions are invalid
          | _, _, _ => ∅
}

-- 3. Show that ⟨⟨⟩⟨⟩⟩ ∈ L PPar
theorem e3 : [SigmaPar.lpar,SigmaPar.lpar, SigmaPar.rpar,SigmaPar.lpar,SigmaPar.rpar, SigmaPar.rpar] ∈ L PPar := by
     sorry

/-
Sequence of IDs proving the string is in L PPar:

(q0, lpar lpar rpar lpar rpar rpar, Z) ->
(q0, lpar rpar lpar rpar rpar, X Z) ->
(q0, rpar lpar rpar rpar, X X Z) ->
(q0, lpar rpar rpar, X Z) ->
(q0, rpar rpar, X X Z) ->
(q0, rpar, X Z) ->
(q0, ε, Z) ->
(qf, ε, Z)

Because qf ∈ F, the word is accepted.
-/
end ex5
