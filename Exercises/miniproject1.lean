/-
COMP2012 (LAC) 2026

Mini Project 1

1. Show that regular languages are closed under complement.
2. Define a regular expression whose language is the binary numbers
   divisible by 3 (little endian, least significant digit first).
3. Construct the negation of this regular expression using 1.
4. Is there a difference if we had used big endian?

State explicitly, in a comment here, which of the above tasks (if
any) you used AI assistance for, and how.

Don't change anything else in this file!
-/
import Mathlib.Tactic.DeriveFintype
import Proofs.Lang
import Proofs.Autom
import Proofs.RE

open Lang Dfa DFA Nfa NFA Re RE Kleene
open Lang.Examples
open SigmaABC

/- ================================================================
   Task 1: Regular languages are closed under complement.

   We say `L` is regular if it is the language of some DFA (this is
   the same definition used in Exercise 4).
   ================================================================ -/

def REG {Sigma : Type} [Alphabet Sigma] : Set (Lang Sigma)
:= { lang | ∃ A : DFA Sigma, Dfa.L A = lang }

/-
Construct, for every DFA `A`, a DFA `dfaCompl A` whose language is
the complement of `A`'s language. Hint: you only need to change one
field of the structure.
-/
def dfaCompl {Sigma : Type} [Alphabet Sigma] (A : DFA Sigma) : DFA Sigma
:= sorry

/-
Prove that your construction is correct. Hint: first show, by
induction on `w`, that `δ_star (dfaCompl A) q w = δ_star A q w` for
every state `q`.
-/
theorem dfaCompl_ok {Sigma : Type} [Alphabet Sigma] (A : DFA Sigma) :
    Dfa.L (dfaCompl A) = (Dfa.L A)ᶜ
:= sorry

/-
Conclude that `REG` is closed under complement.
-/
theorem REG_closed_compl {Sigma : Type} [Alphabet Sigma] :
    ∀ L : Lang Sigma, L ∈ REG → Lᶜ ∈ REG
:= sorry

/- ================================================================
   Task 2: A regular expression for binary numbers divisible by 3,
   little endian (least significant digit first).

   Recall `val` and `div3` from the lectures (`Proofs/Lang.lean`):

     def val : Word SigmaBin → ℕ
     | []       => 0
     | (x :: xs) => x + 2 * val xs

     abbrev div3 : Lang SigmaBin
     := { w | val w ≡ 0 [MOD 3]}

   Define a regular expression `div3RE : RE SigmaBin` whose language
   (informally) is `div3`.

   Hint: for a DFA processing bits *most*-significant-bit first, the
   state `r ↦ (2r + b) mod 3` is all you need, because reading one
   more bit always means "shift by one binary digit". Here, bits
   arrive *least*-significant first, so the weight `2^i mod 3` of
   the `i`-th bit depends on the parity of `i` (it is 1, 2, 1, 2, ...
   since `2^2 ≡ 1 mod 3`). Think about what extra piece of state you
   need to track alongside the remainder, and/or consider processing
   the input two bits at a time.

   You are not required to give a Lean proof that
   `Re.L div3RE = div3` (this is a genuinely substantial undertaking
   given the tools introduced in lectures) -- a handful of worked
   examples showing `div3RE` accepts/rejects some concrete words is
   enough to demonstrate your construction is right.
   ================================================================ -/

open Lang.Examples (SigmaBin val div3)

def div3RE : RE SigmaBin := sorry

-- some words to check your definition against (uncomment and prove)
-- example : ([] : Word SigmaBin) ∈ Re.L div3RE := sorry
-- example : ([0, 1, 1] : Word SigmaBin) ∈ Re.L div3RE := sorry
-- example : ([1, 0, 1] : Word SigmaBin) ∉ Re.L div3RE := sorry

/- ================================================================
   Task 3: The negation of `div3RE`, constructed using Task 1.

   Regular expressions can be translated to NFAs (`re2nfa`) and NFAs
   to DFAs (`nfa2dfa`, see `Proofs/Autom.lean`/`Proofs/RE.lean`), so
   the language of any regular expression is regular. Using this and
   your `dfaCompl` construction from Task 1, construct a DFA whose
   language is the *complement* of `div3RE`'s language.

   You may either run the (large!) pipeline `nfa2dfa (re2nfa
   div3RE)` and complement that, or -- much more practically --
   define your own small DFA equivalent to `div3RE` directly (the
   automaton you designed to come up with `div3RE` in Task 2 is a
   good candidate) and complement that instead. Either way you must
   go via `dfaCompl`.
   ================================================================ -/

def negDiv3 : DFA SigmaBin := sorry

-- some words to check your construction against (uncomment and prove)
-- example : ([1, 0, 1] : Word SigmaBin) ∈ Dfa.L negDiv3 := sorry
-- example : ([0, 1, 1] : Word SigmaBin) ∉ Dfa.L negDiv3 := sorry

/- ================================================================
   Task 4: Does big endian make a difference?

   Answer in English in this comment. Think about what state a DFA
   needs to track when it reads bits most-significant-digit first,
   versus least-significant-digit first, and how that affects the
   size of the automaton and the shape of the regular expression.
   ================================================================ -/
