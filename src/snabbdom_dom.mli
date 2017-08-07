(* Bindings to some standard DOM functions. Some of these might be implemented in the Bucklescript,
   standard libraries, at which point they can be removed from here. *)

type element = Dom.element
val focus : element -> unit
val document : Dom.document
val get_element_by_id : Dom.document -> string -> element option
val stop_propagation : 'a Dom.event_like -> unit
val prevent_default : 'a Dom.event_like -> unit
val get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like
val get_value : 'a Dom.eventTarget_like -> string
val get_event_key : Dom.keyboardEvent -> string
val is_checked : 'a Dom.eventTarget_like -> bool
val set_timeout : (unit -> unit) -> int -> int
