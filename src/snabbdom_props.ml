open Snabbdom_base

external module_props : snabbdom_module = "default" [@@bs.module "snabbdom/modules/props"]

(* Prop module *)
let prop key (value:string) = Snabbdom_vnode.set_in_data [|"props"; key|] value
