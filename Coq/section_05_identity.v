Require Export section_04_inductive.

(** Section 5. Identity types *)

(** Section 5.1 The definition of identity types *)

Inductive Id {A} (a : A) : A -> Type :=
| refl : Id a a.

Arguments refl {A} {a}.
  
Notation "x '==' y" := (Id x y) (at level 80).

(** Section 5.2 The groupoidal structure of types *)

(** Definition 5.2.1 *)

Definition concat {A} {x y z : A} (p : x == y) (q : y == z) : x == z.
Proof.
  destruct p.
  exact q.
Defined.

Definition concat' {A} {x y z : A} (q : y == z) (p : x == y) : x == z :=
  concat p q.

(* A little short-hand tactic. *)
Ltac transitivity x := apply (@concat _ _ x).

(** Definition 5.2.2 *)

Lemma inv {A} {x y : A} (p : x == y) : y == x.
Proof.
  destruct p.
  reflexivity.
Defined.

(** Definition 5.2.3 *)

Lemma assoc {A} {x y z w : A} (p : x == y) (q : y == z) (r : z == w) :
  concat (concat p q) r == concat p (concat q r).
Proof.
  destruct p.
  reflexivity.
Defined.

(** Definition 5.2.4 *)

Lemma left_unit {A} {x y : A} (p : x == y) :
  concat refl p == p.
Proof. reflexivity. Defined.

Lemma right_unit {A} {x y : A} (p : x == y) :
  concat p refl == p.
Proof.
  destruct p.
  reflexivity.
Defined.

(** Definition 5.2.5 *)

Lemma left_inv {A} {x y : A} (p : x == y) :
  concat (inv p) p == refl.
Proof.
  destruct p.
  reflexivity.
Defined.

Lemma right_inv {A} {x y : A} (p : x == y) :
  concat p (inv p) == refl.
Proof.
  destruct p.
  reflexivity.
Defined.

(** Section 5.3 The action on paths of functions *)

(** Definition 5.3.1 *)

Lemma ap {A B} (f : A -> B) {x y : A} (p : x == y) : (f x) == (f y).
Proof.
  destruct p.
  reflexivity.
Defined.

Lemma ap_id {A : Type} {x y} (p : x == y) : p == ap (fun (x : A) => x) p.
Proof.
  destruct p.
  reflexivity.
Defined.

Lemma ap_comp {A B C : Type} (g : B -> C) (f : A -> B) {x y} (p : x == y) :
  ap g (ap f p) == ap (comp g f) p.
Proof.
  destruct p.
  reflexivity.
Defined.

(** Definition 5.3.2 *)

Lemma ap_refl {A B : Type} (f : A -> B) {x : A} :
  ap f (@refl A x) == @refl B (f x).
Proof.
  reflexivity.
Defined.

Lemma ap_concat {A B : Type} (f : A -> B) {x y z} (p : x == y) (q : y == z) :
  ap f (concat p q) == concat (ap f p) (ap f q).
Proof.
  destruct p.
  reflexivity.
Defined.

Lemma ap_inv {A B : Type} (f : A -> B) {x y} (p : x == y) :
  ap f (inv p) == inv (ap f p).
Proof.
  destruct p.
  reflexivity.
Defined.

(** Section 5.4 Transport *)

(** Definition 5.4.1 *)

Lemma tr {A} (B : A -> Type) {x y : A} (p : x == y) : B x -> B y.
Proof.
  destruct p.
  exact (fun x => x). (* Why can I not use the id here? *)
Defined.

(** Definition 5.4.2 *)

Definition apd {A} {B : A -> Type} (f : forall x, B x) {x y} (p : x == y) :
  Id (tr B p (f x)) (f y).
Proof.
  destruct p.
  reflexivity.
Defined.

(** Exercises *)

(** Exercise 5.1 *)

Definition is_odd_N (n : N) : Type.
Proof.
  induction n as [|n T].
  - exact empty.
  - exact (neg T).
Defined.

(** Exercise 5.2 *)

Definition distributive_inv_concat {A} {x y z : A} (p : x == y) (q : y == z) :
  inv (concat p q) == concat (inv q) (inv p).
Proof.
  destruct p. destruct q. reflexivity.
Defined.

(** Exercise 5.3 *)

Definition lift_path {A} {B : A -> Type} {x y : A} (p : x == y) (b : B x) :
  pair x b == pair y (tr B p b).
Proof.
  destruct p.
  reflexivity.
Defined.

(** Exercise 5.4 *)

(** Exercise 5.4.a *)

Lemma left_unit_law_add_N (n : N) : zero_N + n == n.
Proof.
  induction n.
  - reflexivity.
  - cbn. now apply ap.
Defined.

Lemma right_unit_law_add_N (n : N) : n + zero_N == n.
Proof.
  reflexivity.
Defined.

Lemma left_successor_law_add_N (m n : N) :
  (succ_N m) + n == succ_N (m + n).
Proof.
  induction n.
  - reflexivity.
  - cbn. now apply ap.
Defined.

Lemma right_successor_law_add_N (m n : N) :
  m + (succ_N n) == succ_N (m + n).
Proof.
  reflexivity.
Defined.

(** Exercise 5.4.b *)

Theorem associative_add_N (m n k : N) :
  (m + n) + k == m + (n + k).
Proof.
  induction k.
  - reflexivity.
  - cbn. now apply ap.
Defined.

Theorem commutative_add_N (m n : N) :
  m + n == n + m.
Proof.
  induction n.
  - apply inv, left_unit_law_add_N.
  - transitivity (succ_N (n + m)).
    * now apply (ap succ_N).
    * apply inv, left_successor_law_add_N.
Defined.

(** Exercise 5.4.c *)

Definition left_zero_law_mul_N (n : N) :
  zero_N * n == zero_N.
Proof.
  induction n.
  - reflexivity.
  - transitivity (zero_N * n).
    * apply left_unit_law_add_N.
    * assumption.
Defined.

Definition right_zero_law_mul_N (n : N) :
  n * zero_N == zero_N.
Proof. reflexivity. Defined.

Definition left_unit_law_mul_N (n : N) :
  one_N * n == n.
Proof.
  induction n.
  - reflexivity.
  - transitivity (succ_N (one_N * n)).
    * apply commutative_add_N.
    * now apply (ap succ_N).
Defined.

Definition right_unit_law_mul_N (n : N) :
  n * one_N == n.
Proof.
  reflexivity.
Defined.

Definition left_successor_law_mul_N (m n : N) :
  (succ_N m) * n == (m * n) + n.
Proof.
  induction n.
  - reflexivity.
  - transitivity (succ_N (m + ((succ_N m) * n))).
    * apply left_successor_law_add_N.
    * apply (ap succ_N).
      transitivity (m + ((m * n) + n)).
      ** now apply (ap (add_N m)).
      ** apply inv, associative_add_N.
Defined.

Definition right_successor_law_mul_N (m n : N) :
  m * (succ_N n) == m + (m * n).
Proof. reflexivity. Defined.

(** Exercise 5.4.d *)

Definition left_distributive_mul_add_N (m n k : N) :
  m * (n + k) == (m * n) + (m * k).
Proof.
  induction k.
  - reflexivity.
  - transitivity (m + (m * n + m * k)).
    * now apply (ap (add_N m)).
    * { transitivity (m + m * n + m * k).
        - apply inv, associative_add_N.
        - transitivity ((m * n + m) + (m * k)).
          * apply (ap (add_N' (m * k))), commutative_add_N.
          * apply associative_add_N.
      }
Defined.

Definition add_pairs (m n m' n' : N) :
  (m + n) + (m' + n') == (m + m') + (n + n').
Proof.
  transitivity (m + (n + (m' + n'))).
  - apply associative_add_N.
  - transitivity (m + (m' + (n + n'))).
    * { apply (ap (add_N m)).
        transitivity ((n + m') + n').
        - apply inv, associative_add_N.
        - transitivity ((m' + n) + n').
          * apply (ap (add_N' n')), commutative_add_N.
          * apply associative_add_N.
      }
    * apply inv, associative_add_N.
Defined.

Definition right_distributive_mul_add_N (m n k : N) :
  (m + n) * k == m * k + n * k.
Proof.
  induction k as [|k p].
  - reflexivity.
  - transitivity ((m + n) + (m * k + n * k)).
    * now apply (ap (add_N (m + n))).
    * now apply add_pairs.
Defined.

(** Exercise 5.4.e *)
    
Definition associative_mul_N (m n k : N) :
  (m * n) * k == m * (n * k).
Proof.
  induction k.
  - reflexivity.
  - transitivity (m * n + m * (n * k)).
    * now apply (ap (add_N (m * n))).
    * apply inv, left_distributive_mul_add_N.
Defined.

Definition commutative_mul_N (m n : N) :
  m * n == n * m.
Proof.
  induction n.
  - apply inv, left_zero_law_mul_N.
  - transitivity (m * n + m).
    * apply commutative_add_N.
    * transitivity ((n * m) + m).
      ** now apply (ap (add_N' m)).
      ** apply inv, left_successor_law_mul_N.
Defined.

(** Exercise 5.6 *)

Definition Mac_Lane_pentagon {A} {a b c d e : A}
           (p : a == b) (q : b == c) (r : c == d) (s : d == e) :
  concat
    ( concat
        ( ap (concat' s) (assoc p q r))
        ( assoc p (concat q r) s))
    ( ap (concat p) (assoc q r s))
  ==
  concat (assoc (concat p q) r s) (assoc p q (concat r s)).
Proof.
  destruct p.
  destruct q.
  reflexivity.
Defined.
