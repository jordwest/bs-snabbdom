(** The Data module provides functions for interacting with the data object passed to snabbdom's h function. *)

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

(* val unsafe_set_in_path : t -> string array -> 'a -> t *)

(** Sets an object property somewhere in the data object.

    Pass an array of strings representing the path to the property to be set, followed
    by the property value. Intermediate objects will be created if they don't already exist.
    
    For example, to add a property like the following (in JavaScript):
    {[{ style: { color: '#000' } }]}

    Use:
    {[let data = set_in_path data \[|"style"; "color"|\] "#000"]}
*)
val set_in_path : t -> string array -> 'a -> t
