(** Main snabbdom functions *)

(** This snabbdom function is not supported *)
exception Not_supported

(** A Snabbdom patch function (returned by `init`) which takes an old DOM element or vnode and patches it to match a new vnode *)
type patchfn = Snabbdom_vnode.t -> Snabbdom_vnode.t -> unit

(** This type refers to a Snabbdom Module. Any
    modules with this type can be passed to `init` to
    create a patching function.
    
    {{:https://github.com/snabbdom/snabbdom#modules-documentation} See the Snabbdom documentation for details on modules}

    If you've built a custom module, you can define it using:
    {[external my_module : snabbdom_module = "default" \[\@\@bs.module "path/to/module"\]]}
    *)
type snabbdom_module

(** Create a Snabbdom patch function from an array of snabbdom modules. *)
val init : snabbdom_module array -> patchfn

(** The recommended function for creating Snabbdom vnodes. Note this function
    doesn't work exactly like {{:https://github.com/snabbdom/snabbdom#snabbdomh} Snabbdom's `h` function}

    Since we're working in a different language, bs-snabbdom provides a slightly different
    h function for constructing the vnodes that better works with OCaml.

    The first parameter is the same as Snabbdom's - an html selector describing the element
    type and any classes/id to apply to the element.

    The second parameter takes a list of {!type:vnode_transformer} functions, which
    specify how to create the vnode. Some transformers are implemented in this
    module below.

    Usage example:
    {[h "div.section" \[
  style "border" "1px solid black";
  text "Hello World!"
\]]}
    *)
val h : string -> Snabbdom_vnode.transformer list -> Snabbdom_vnode.t

(** Add child vnodes *)
val children : Snabbdom_vnode.t list -> Snabbdom_vnode.transformer

(** Adds text to the body of the node *)
val text : string -> Snabbdom_vnode.transformer

(** Sets the Snabbdom key for this node. Use this on
    lists of items to help Snabbdom reconcile the old
    and new nodes and reuse nodes that belong to the
    same key when reordering the list. *)
val key : string -> Snabbdom_vnode.transformer

(** Don't transform the {!type:Snabbdom_external.VNode.t}. Can be useful for if statements:

    {[if is_active then style "is-active" else nothing]}
*)
val nothing : Snabbdom_vnode.transformer

val module_attributes : snabbdom_module
val attr : string -> string -> Snabbdom_vnode.transformer

val module_class : snabbdom_module
val class_name : string -> Snabbdom_vnode.transformer

val module_style : snabbdom_module
val style : string -> string -> Snabbdom_vnode.transformer
val style_delayed : string -> string -> Snabbdom_vnode.transformer
val style_remove : string -> string -> Snabbdom_vnode.transformer
