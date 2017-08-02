(** Main snabbdom functions *)

(** This snabbdom function is not supported *)
exception Not_supported

(** A node cannot have both text and child nodes *)
exception Children_not_allowed_with_text

(** node_params are the parameters Snabbdom uses to generate a vnode.
    We pass them around in a tuple here, with the following elements:
    
        1. Snabbdom data. This is the actual data object passed to Snabbdom's
            actual `h` function.
        2. 
*)
type node_params = ( Snabbdom_external.Data.t * Snabbdom_external.VNode.t list * string option )

(** A node_params_transformer is any function which modifies
    the parameters Snabbdom uses to generate a vnode.
 *)
type node_params_transformer = node_params -> node_params

(** The recommended function for creating Snabbdom vnodes. Note this function
    doesn't work exactly like {{:https://github.com/snabbdom/snabbdom#snabbdomh} Snabbdom's `h` function}

    Since we're working in a typed language, bs-snabbdom provides a different
    method for constructing the vnodes.

    {e Note: If you really need it, the lower level binding is also defined in {!val:Snabbdom_external.h}.}

    The first parameter is the same as Snabbdom's - an html selector describing the element
    type and any classes/id to apply to the element.

    The second parameter takes a list of {!type:node_params_transformer} functions, which
    specify how to set up the node. Some transformers are implemented in this
    module below.

    Usage example:
    {[h "div.section" \[
  style "border" "1px solid black";
  text "Hello World!"
\]]}
    *)
val h : string -> node_params_transformer list -> Snabbdom_external.VNode.t

val set_data_path : string array -> 'a -> node_params_transformer

(** Add child vnodes *)
val children : Snabbdom_external.VNode.t list -> node_params_transformer

(** Sets the text in the body of the node *)
val text : string -> node_params_transformer

(** Sets the Snabbdom key for this node. Use this on
    lists of items to help Snabbdom reconcile the old
    and new nodes and reuse nodes that belong to the
    same key when reordering the list. *)
val key : string -> node_params_transformer

(** This does nothing. Can be useful for if statements:

    {[if is_active then style "is-active" else nothing]}
*)
val nothing : node_params_transformer

val module_attributes : Snabbdom_external.snabbdom_module
val attr : string -> string -> node_params_transformer

val module_class : Snabbdom_external.snabbdom_module
val class_name : string -> node_params_transformer

val module_style : Snabbdom_external.snabbdom_module
val style : string -> string -> node_params_transformer
val style_delayed : string -> string -> node_params_transformer
val style_remove : string -> string -> node_params_transformer
