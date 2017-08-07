(** The VNode module provides types and functions for interacting with native Snabbdom vdom nodes *)

(** Represents a Snabbdom vnode *)
type t

(** A transformer is any function which modifies a Snabbdom vnode. *)
type transformer = t -> t

val empty : unit -> t
val set_sel : t -> string -> unit
val set_data : t -> Snabbdom_data.t -> unit
val set_children : t -> t array -> unit
val set_text : t -> string -> unit
val set_key : t -> string -> unit
val clear_text : t -> unit

val get_children : t -> t array option
val get_elm : t -> Dom.element option
val get_text : t -> string option

(** Sets an object property somewhere in the vnode data object.

    Pass an array of strings representing the path to the property to be set, followed
    by the property value. Intermediate objects will be created if they don't already exist.
    
    For example, to set the vnode's key property like the following (in JavaScript):
    {[vnode.data.ns = "xyz"]}

    Use:
    {[let vnode = set_in_data \[|"ns"|\] "xyz" vnode]}
*)
val set_in_data : string array -> 'a -> t -> t

(** Exception raised when {!val:from_dom_id} is called with an
    element id that does not exist. *)
exception Element_with_id_not_found of string

(** Create a VNode from an element in the DOM with the specified id.

    This function may raise an {!exception:Element_with_id_not_found} exception.
*)
val from_dom_id : string -> t

(** Compile-time conversion of DOM elements to a Snabbdom vnode.

    This function doesn't actually do anything at runtime.
    Since the Snabbdom patch function allows us to use
    an existing DOM element as an 'old' vnode, this function
    just explicitly tells the compiler that we know what we're
    doing.
*)
val of_dom_element : Dom.element -> t
