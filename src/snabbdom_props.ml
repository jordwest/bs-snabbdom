open Snabbdom_external

type prop = string * string
type style = string * string
type 'a event_cb = ('a -> unit)

type event_cb_type =
    | Event of Dom.event event_cb
    | EventMouse of Dom.event event_cb
    | EventKeyboard of Dom.keyboardEvent event_cb
    | EventDrag of Dom.dragEvent event_cb

type hook_cb =
    | Zero of (unit -> unit)
    | One of (vnode -> unit)
    | Two of (vnode -> vnode -> unit)

type node_info = Text of string
               | Style of style
               | StyleDelay of style
               | StyleRemove of style
               | Props of prop list
               | Prop of string * string
               | Attr of string * string
               | Children of vnode list
               | EventListener of (string * event_cb_type)
               | Hook of (string * hook_cb)
               | Key of string
               | Class of string
               | Ignore

let prop key value = Prop (key, value)
let attr key value = Attr (key, value)
let style key value = Style (key, value)
