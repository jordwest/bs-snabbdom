module VNode = Snabbdom_vnode

let hook key cb =
    VNode.set_in_data [|"hook"; key|] cb
let hook0 key (cb: unit -> unit) = hook key cb
let hook1 key (cb: VNode.t -> unit) = hook key cb
let hook2 key (cb: VNode.t -> VNode.t -> unit) = hook key cb

let insert cb = hook1 "insert" cb

let autofocus = insert (fun(vnode) -> match VNode.get_elm vnode with
    | Some elm -> Snabbdom_dom.focus elm;
    | None -> ()
);
