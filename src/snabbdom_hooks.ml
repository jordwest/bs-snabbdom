open Snabbdom_external

let insert cb = Snabbdom_props.Hook ("insert", (One cb))

let autofocus = insert (fun(n) -> focus (get_elm n); ());
