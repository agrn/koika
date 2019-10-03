Require Import Coq.Strings.String Coq.Lists.List.
Require Import SGA.Environments SGA.Types SGA.Circuits SGA.Primitives.
Import ListNotations.

Section Interop.
  Context {custom_ufn_t custom_fn_t: Type}.

  Inductive interop_ufn_t :=
  | UPrimFn (fn: prim_ufn_t)
  | UCustomFn (fn: custom_ufn_t).

  Inductive interop_fn_t :=
  | PrimFn (fn: prim_fn_t)
  | CustomFn (fn: custom_fn_t).

  Definition interop_Sigma
             (Sigma: custom_fn_t -> ExternalSignature)
    : interop_fn_t -> ExternalSignature  :=
    fun fn => match fn with
           | PrimFn fn => prim_Sigma fn
           | CustomFn fn => Sigma fn
           end.

  Definition interop_uSigma
             (uSigma: custom_ufn_t -> type -> type -> result custom_fn_t fn_tc_error)
             (fn: interop_ufn_t)
             (tau1 tau2: type)
    : result interop_fn_t fn_tc_error :=
    match fn with
    | UPrimFn fn => let/res fn := prim_uSigma fn tau1 tau2 in
                   Success (PrimFn fn)
    | UCustomFn fn => let/res fn := uSigma fn tau1 tau2 in
                     Success (CustomFn fn)
    end.

  Definition interop_sigma
             {Sigma: custom_fn_t -> ExternalSignature}
             (sigma: forall fn: custom_fn_t, Sigma fn)
    : forall fn: interop_fn_t, interop_Sigma Sigma fn :=
    fun fn => match fn with
           | PrimFn fn => prim_sigma fn
           | CustomFn fn => sigma fn
           end.
End Interop.

Inductive interop_empty_t :=.
Definition interop_empty_Sigma (fn: interop_empty_t)
  : ExternalSignature := match fn with end.
Definition interop_empty_uSigma (fn: interop_empty_t) (_ _: type)
  : result interop_empty_t fn_tc_error := match fn with end.
Definition interop_empty_sigma fn
  : interop_empty_Sigma fn := match fn with end.
Definition interop_empty_fn_names (fn: interop_empty_t)
  : string := match fn with end.

Arguments interop_fn_t: clear implicits.
Arguments interop_ufn_t: clear implicits.

Definition interop_minimal_ufn_t := interop_ufn_t interop_empty_t.
Definition interop_minimal_fn_t := interop_fn_t interop_empty_t.
Definition interop_minimal_Sigma idx := interop_Sigma interop_empty_Sigma idx.
Definition interop_minimal_uSigma := interop_uSigma interop_empty_uSigma.
Definition interop_minimal_sigma := interop_sigma interop_empty_sigma.

Section Packages.
  (** [rule_name_t]: The type of rule names.
      Typically an inductive [rule1 | rule2 | …]. **)
  Context {rule_name_t: Type}.

  (** [var_t]: The type of variables used in let bindings.
      Typically [string]. *)
  Context {var_t: Type}.

  (** [reg_t]: The type of registers used in the program.
      Typically an inductive [R0 | R1 | …] *)
  Context {reg_t: Type}.

  (** [custom_fn_t]: The type of custom functions used in the program.
      The [fn_t] used by the program itself should be [interop_fn_t
      custom_fn_t], so the program can call primitives using (PrimFn …)
      and custom functions using (CustomFn …). *)
  Context {custom_fn_t: Type}.

  Record sga_package_t :=
    {
      (** [sga_reg_names]: These names are used to generate readable code. *)
      sga_reg_names: reg_t -> string;
      (** [sga_reg_types]: The type of data stored in each register. *)
      sga_reg_types: reg_t -> type;
      (** [sga_reg_types]: The type of data stored in each register. *)
      sga_reg_init: forall r: reg_t, sga_reg_types r;
      (** [sga_reg_finite]: We need to be able to enumerate the set of registers
          that the program uses. *)
      sga_reg_finite: FiniteType reg_t;

      (** [sga_custom_fn_types]: The signature of each function. *)
      sga_custom_fn_types: forall fn: custom_fn_t, ExternalSignature;

      (** [sga_rules]: The rules of the program. **)
      sga_rules: forall _: rule_name_t,
          TypedSyntax.rule var_t sga_reg_types (interop_Sigma sga_custom_fn_types);
      (** [sga_rule_names]: These names are used to generate readable code. **)
      sga_rule_names: rule_name_t -> string;

      (** [sga_scheduler]: The scheduler. **)
      sga_scheduler: TypedSyntax.scheduler rule_name_t;

      (** [sga_module_name]: The name of the current package. **)
      sga_module_name: string
    }.

  Record circuit_package_t :=
    {
      cp_pkg: sga_package_t;

      (** [cp_reg_env]: This describes how the program concretely stores maps
        keyed by registers (this is used in the type of [cp_circuit], which is
        essentially a list of circuits, one per register. *)
      cp_reg_Env: Env reg_t;

      (** [cp_circuit]: The actual circuit scheduler circuit generated by the
        compiler (really a list of circuits, one per register).  This should
        use [interop_fn_t custom_fn_t] as the function type (and
        [interop_fn_Sigma sga_custom_fn_types] as the environment of
        signatures). *)
      cp_circuit: @state_transition_circuit
                    rule_name_t reg_t (@interop_fn_t custom_fn_t)
                    (cp_pkg.(sga_reg_types)) (interop_Sigma cp_pkg.(sga_custom_fn_types))
                    cp_reg_Env;
    }.

  Record verilog_package_t :=
    {
      vp_pkg: sga_package_t;

      (** [vp_custom_fn_names]: A map from custom functions to Verilog
          implementations. *)
      vp_custom_fn_names: forall fn: custom_fn_t, string;

      (** [vp_external_rules]: A list of rule names to be replaced with
          Verilog implementations *)
      vp_external_rules: list rule_name_t
    }.

  Record sim_package_t :=
    {
      sp_pkg: sga_package_t;

      (** [sp_var_names]: These names are used to generate readable code. *)
      sp_var_names: var_t -> string;

      (** [sp_custom_fn_names]: A map from custom functions to C++
          implementations. *)
      sp_custom_fn_names: forall fn: custom_fn_t, string;

      (** [sp_extfuns]: A piece of C++ code implementing the custom external
          functions used by the program.  This is only needed if [sp_pkg] has a
          non-empty [custom_fn_t].  It should implement a class called
          'extfuns', with public functions named consistently with
          [sp_custom_fn_names] **)
      sp_extfuns: option string
    }.
End Packages.

Section TypeConv.
  Fixpoint struct_to_list {A} (f: forall tau: type, type_denote tau -> A)
           (fields: list (string * type)) (v: struct_denote fields): list (string * A) :=
    match fields return struct_denote fields -> list (string * A) with
    | [] => fun v => []
    | (nm, tau) :: fields => fun v => (nm, f tau (fst v)) :: struct_to_list f fields (snd v)
    end v.

  Definition struct_of_list_fn_t A :=
    forall a: A, { tau: type & type_denote tau }.

  Definition struct_of_list_fields {A} (f: struct_of_list_fn_t A) (aa: list (string * A)) :=
    List.map (fun a => (fst a, projT1 (f (snd a)))) aa.

  Fixpoint struct_of_list {A} (f: struct_of_list_fn_t A) (aa: list (string * A))
    : struct_denote (struct_of_list_fields f aa) :=
    match aa with
    | [] => tt
    | a :: aa => (projT2 (f (snd a)), struct_of_list f aa)
    end.

  Lemma struct_of_list_to_list {A}
        (f_ls: forall tau: type, type_denote tau -> A)
        (f_sl: struct_of_list_fn_t A) :
    (forall a, f_ls (projT1 (f_sl a)) (projT2 (f_sl a)) = a) ->
    (* (forall a, f_ls (projT1 (f_sl a)) = a) -> *)
    forall (aa: list (string * A)),
      struct_to_list f_ls _ (struct_of_list f_sl aa) = aa.
  Proof.
    induction aa; cbn.
    - reflexivity.
    - setoid_rewrite IHaa. rewrite H; destruct a; reflexivity.
  Qed.

  Fixpoint struct_to_list_of_list_cast {A}
        (f_ls: forall tau: type, type_denote tau -> A)
        (f_sl: struct_of_list_fn_t A)
        (pr: forall tau a, projT1 (f_sl (f_ls tau a)) = tau)
        (fields: list (string * type)) (v: struct_denote fields) {struct fields}:
    struct_of_list_fields f_sl (struct_to_list f_ls fields v) = fields.
  Proof.
    destruct fields as [| (nm, tau) fields]; cbn.
    - reflexivity.
    - unfold struct_of_list_fields in *;
        rewrite struct_to_list_of_list_cast by eauto.
      rewrite pr; reflexivity.
  Defined.

  Lemma struct_to_list_of_list {A}
        (f_ls: forall tau: type, type_denote tau -> A)
        (f_sl: struct_of_list_fn_t A)
        (fields: list (string * type))
        (pr: forall tau a, f_sl (f_ls tau a) = existT _ tau a):
    forall (v: struct_denote fields),
      (struct_of_list f_sl (struct_to_list f_ls _ v)) =
      ltac:(rewrite struct_to_list_of_list_cast by (intros; rewrite pr; eauto); exact v).
  Proof.
    induction fields as [| (nm, tau) fields]; cbn; destruct v; cbn in *.
    - reflexivity.
    - rewrite IHfields; clear IHfields.
      unfold eq_ind_r, eq_ind, eq_sym.
      set (struct_to_list_of_list_cast _ _ _ _ _) as Hcast; clearbody Hcast.
      change (fold_right _ _ ?fields) with (struct_denote fields) in *.
      set (struct_to_list f_ls fields f) as sfs in *; clearbody sfs;
        destruct Hcast; cbn.
      set (pr _ _) as pr'; clearbody pr'.
      set ((f_sl (f_ls tau t))) as a in *; clearbody a.
      set (struct_of_list_fields f_sl sfs) as ssfs in *.
      destruct a; cbn; inversion pr'; subst.
      apply Eqdep_dec.inj_pair2_eq_dec in H1; try apply eq_dec; subst.
      setoid_rewrite <- Eqdep_dec.eq_rect_eq_dec; try apply eq_dec.
      reflexivity.
  Qed.
End TypeConv.
