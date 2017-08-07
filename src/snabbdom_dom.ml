type element = Dom.element
external focus : Dom.element -> unit = "focus" [@@bs.send]
external document : Dom.document = "" [@@bs.val]
external get_element_by_id : Dom.document -> string -> Dom.element option = "getElementById" [@@bs.send] [@@bs.return null_to_opt]

external stop_propagation : 'a Dom.event_like -> unit = "stopPropagation" [@@bs.send]
external prevent_default : 'a Dom.event_like -> unit = "preventDefault" [@@bs.send]
external get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like = "target" [@@bs.get]

external get_event_key : Dom.keyboardEvent -> string = "key" [@@bs.get]

external get_value :'a Dom.eventTarget_like -> string = "value" [@@bs.get]
external is_checked : 'a Dom.eventTarget_like -> bool = "checked" [@@bs.get]

external set_timeout : (unit -> unit) -> int -> int = "setTimeout" [@@bs.val]
