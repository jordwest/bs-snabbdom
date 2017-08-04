(** This module contains direct bindings to Snabbdom functions and types. *)

(** This type refers to a Snabbdom Module. Any
    modules with this type can be passed to `init` to
    create a patching function.
    
    {{:https://github.com/snabbdom/snabbdom#modules-documentation} See the Snabbdom documentation for details on modules}

    If you've built a custom module, you can define it using:
    {[external my_module : snabbdom_module = "default" \[\@\@bs.module "path/to/module"\]]}
    *)
type snabbdom_module

(** The Data module provides functions for interacting with the data object passed to snabbdom's h function. *)
module Data : sig

    (** Represents a Snabbdom data object.

    Essentially this is just a standard JavaScript object. For example:

    {[{
    style: {
        color: '#000',
        'font-weight': 'bold'
    },
    on: {
        click: function(e) { e.preventDefault() }
    }
}]}
    *)
    type t

    (** Return a new, empty Snabbdom data object. This is equivalent to JavaScript [{}]*)
    val empty : unit -> t

    (** Sets an object property somewhere in the data object.

        Pass an array of strings representing the path to the property to be set, followed
        by the property value. Intermediate objects will be created if they don't already exist.
        
        For example, to add a property like the following (in JavaScript):
        {[{ style: { color: '#000' } }]}

        Use:
        {[let data = set_in_path data \[|"style"; "color"|\] "#000"]}
    *)
    val set_in_path : t -> string array -> 'a -> t
end

(** The VNode module provides types and functions for interacting with native Snabbdom vdom nodes *)
module VNode : sig

    (** Represents a Snabbdom vnode *)
    type t

    val empty : unit -> t
    val set_sel : t -> string -> unit
    val set_data : t -> Data.t -> unit
    val set_children : t -> t array -> unit
    val set_text : t -> string -> unit
    val set_key : t -> string -> unit
    val clear_text : t -> unit

    val get_children : t -> t array option
    val get_elm : t -> Dom.element option
    val get_text : t -> string option

    (** Sets an object property somewhere in the vnode object.

        Pass an array of strings representing the path to the property to be set, followed
        by the property value. Intermediate objects will be created if they don't already exist.
        
        For example, to set the vnode's key property like the following (in JavaScript):
        {[vnode.key = "xyz"]}

        Use:
        {[let vnode = set_in_path vnode \[|"key"|\] "xyz"]}
    *)
    val set_in_path : t -> string array -> 'a -> t

    (** Compile-time conversion of DOM elements to a Snabbdom vnode.

        This function doesn't actually do anything at runtime.
        Since the Snabbdom patch function allows us to use
        an existing DOM element as an 'old' vnode, this function
        just explicitly tells the compiler that we know what we're
        doing.
    *)
    val of_dom_element : Dom.element -> t
end

(** A Snabbdom patch function (returned by `init`) which takes an old DOM element or vnode and patches it to match a new vnode *)
type patchfn = VNode.t -> VNode.t -> unit

(** Create a Snabbdom patch function from an array of snabbdom modules. *)
val init : snabbdom_module array -> patchfn

module Dom : sig
    val focus : Dom.element -> unit
    val document : Dom.document
    val get_element_by_id : Dom.document -> string -> Dom.element option
    val stop_propagation : 'a Dom.event_like -> unit
    val prevent_default : 'a Dom.event_like -> unit
    val get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like
    val get_value : 'a Dom.eventTarget_like -> string
    val get_event_key : Dom.keyboardEvent -> string
    val is_checked : 'a Dom.eventTarget_like -> bool
    val set_timeout : (unit -> unit) -> int -> int
end
