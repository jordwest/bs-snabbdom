(** Main snabbdom functions *)

(** This snabbdom function is not supported *)
exception Not_supported

(** A vnode_transformer is any function which modifies a Snabbdom vnode. *)
type vnode_transformer = Snabbdom_external.VNode.t -> Snabbdom_external.VNode.t

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
val h : string -> vnode_transformer list -> Snabbdom_external.VNode.t

(** A convenience transformer for setting a path in the `data` element of the vnode. *)
val set_data_path : string array -> 'a -> vnode_transformer

(** Add child vnodes *)
val children : Snabbdom_external.VNode.t list -> vnode_transformer

(** Adds text to the body of the node *)
val text : string -> vnode_transformer

(** Sets the Snabbdom key for this node. Use this on
    lists of items to help Snabbdom reconcile the old
    and new nodes and reuse nodes that belong to the
    same key when reordering the list. *)
val key : string -> vnode_transformer

(** Don't transform the {!type:Snabbdom_external.VNode.t}. Can be useful for if statements:

    {[if is_active then style "is-active" else nothing]}
*)
val nothing : vnode_transformer

val module_attributes : Snabbdom_external.snabbdom_module
val attr : string -> string -> vnode_transformer

val module_class : Snabbdom_external.snabbdom_module
val class_name : string -> vnode_transformer

val module_style : Snabbdom_external.snabbdom_module
val style : string -> string -> vnode_transformer
val style_delayed : string -> string -> vnode_transformer
val style_remove : string -> string -> vnode_transformer
