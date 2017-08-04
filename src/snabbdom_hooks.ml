open Snabbdom_base
module Ex = Snabbdom_external

let hook key cb =
    set_data_path [|"hook"; key|] cb
let hook0 key (cb: unit -> unit) = hook key cb
let hook1 key (cb: Ex.VNode.t -> unit) = hook key cb
let hook2 key (cb: Ex.VNode.t -> Ex.VNode.t -> unit) = hook key cb

let insert cb = hook1 "insert" cb

let autofocus = insert (fun(vnode) -> match Ex.VNode.get_elm vnode with
    | Some elm -> Ex.Dom.focus elm;
    | None -> ()
);
