(* Contains only external Snabbdom bindings *)

type data
type vnode

external _h : string -> data -> vnode array -> vnode = "h" [@@bs.module "snabbdom"]
external _h_text : string -> data -> string -> vnode = "h" [@@bs.module "snabbdom"]
