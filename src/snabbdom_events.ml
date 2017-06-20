
external stop_propagation : 'a Dom.event_like -> unit = "stopPropagation" [@@bs.send]
external prevent_default : 'a Dom.event_like -> unit = "preventDefault" [@@bs.send]
external get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like = "target" [@@bs.get]

external get_value : Dom.eventTarget -> string = "value" [@@bs.get]
external is_checked : Dom.eventTarget -> bool = "checked" [@@bs.get]

external set_timeout : (unit -> unit) -> int -> int = "setTimeout" [@@bs.val]
let next_tick cb =
    let _ = set_timeout cb 0 in
    ()

(* let on event handler = Snabbdom.EventHandler (event, handler) *)
