
external stop_propagation : 'a Dom.event_like -> unit = "stopPropagation" [@@bs.send]
external prevent_default : 'a Dom.event_like -> unit = "preventDefault" [@@bs.send]
external get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like = "target" [@@bs.get]

external get_value :'a Dom.eventTarget_like -> string = "value" [@@bs.get]
external is_checked : 'a Dom.eventTarget_like -> bool = "checked" [@@bs.get]

external set_timeout : (unit -> unit) -> int -> int = "setTimeout" [@@bs.val]
let next_tick cb =
    let _ = set_timeout cb 0 in
    ()

(* let on event handler = Snabbdom.EventHandler (event, handler) *)

module S = Snabbdom_props
let mouse event cb = S.EventListener (event, S.EventMouse cb)

let event event_name cb = S.EventListener (event_name, S.Event cb)
let change = event "change"

let click = mouse "click"
let mousedown = mouse "mousedown"
let mouseup = mouse "mouseup"
let mousemove = mouse "mousemove"

let key event cb = S.EventListener (event, S.EventKeyboard cb)
let keydown = key "keydown"
let keyup = key "keyup"
let keypress = key "keypress"

let drag event cb = S.EventListener (event, S.EventDrag cb)
let dragenter = drag "dragenter"
let dragover = drag "dragover"
let dragleave = drag "dragleave"
let drop = drag "drop"
