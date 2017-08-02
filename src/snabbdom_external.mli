(** This module contains direct bindings to Snabbdom functions and types. *)

(** This type refers to a Snabbdom Module. Any
    modules with this type can be passed to `init` to
    create a patching function.
    
    {{:https://github.com/snabbdom/snabbdom#modules-documentation} See the Snabbdom documentation for details on modules}

    If you've built a custom module, you can define it using:
    {[external my_module : snabbdom_module = "default" \[\@\@bs.module "path/to/module"\]]}
    *)
type snabbdom_module

module Data : sig
    type t
    val empty : unit -> t
    val set_in_path : t -> string array -> 'a -> t
end

module VNode : sig
    type t

    val get_elm : t -> Dom.element
end

(** A Snabbdom patch function (returned by `init`) which takes an old DOM element or vnode and patches it to match a new vnode *)
type patchfn = VNode.t -> VNode.t -> unit

(** Snabbdom's `h` function for building a vnode from a set of data.

    Generally, you'll want to use {!val:Snabbdom_base.h} instead.

    This function is only used when the node contains child vnodes or is empty.
    Use {!val:h_text} if the contents of the vnode is only text.
*)
val h : string -> Data.t -> VNode.t array -> VNode.t

(** Snabbdom's `h` function, but used when the vnode content is only text instead of other vnodes. *)
val h_text : string -> Data.t -> string -> VNode.t

(** Create a Snabbdom patch function from an array of snabbdom modules. *)
val init : snabbdom_module array -> patchfn

(** Compile-time conversion of DOM elements to a Snabbdom vnode.

    This function doesn't actually do anything at runtime.
    Since the Snabbdom patch function allows us to use
    an existing DOM element as an 'old' vnode, this function
    just explicitly tells the compiler that we know what we're
    doing.
*)
val vnode_of_dom : Dom.element -> VNode.t

module Dom : sig
    val focus : Dom.element -> unit
    val document : Dom.document
    val get_element_by_id : Dom.document -> string -> Dom.element option
    val stop_propagation : 'a Dom.event_like -> unit
    val prevent_default : 'a Dom.event_like -> unit
    val get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like
    val get_value : 'a Dom.eventTarget_like -> string
    val is_checked : 'a Dom.eventTarget_like -> bool
    val set_timeout : (unit -> unit) -> int -> int
end
