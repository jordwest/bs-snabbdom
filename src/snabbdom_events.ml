open Snabbdom_base
open Snabbdom_external.Dom

let next_tick cb =
    let _ = set_timeout cb 0 in
    ()

type 'a event_cb = ('a -> unit)
let mouse event (cb:Dom.mouseEvent event_cb) = set_event_listener event cb

let event event (cb:Dom.event event_cb) = set_event_listener event cb
let change = event "change"

let click = mouse "click"
let mousedown = mouse "mousedown"
let mouseup = mouse "mouseup"
let mousemove = mouse "mousemove"

let keyboard event (cb:Dom.keyboardEvent event_cb) = set_event_listener event cb
let keydown = keyboard "keydown"
let keyup = keyboard "keyup"
let keypress = keyboard "keypress"

let drag event (cb:Dom.dragEvent event_cb) = set_event_listener event cb
let dragenter = drag "dragenter"
let dragover = drag "dragover"
let dragleave = drag "dragleave"
let drop = drag "drop"
