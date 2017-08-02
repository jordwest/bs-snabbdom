open Snabbdom_base
open Snabbdom_external

let insert cb = set_hook1 "insert" cb

let autofocus = insert (fun(n) -> Dom.focus (VNode.get_elm n); ());
