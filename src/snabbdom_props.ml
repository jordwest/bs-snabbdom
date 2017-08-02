open Snabbdom_base
open Snabbdom_external

external module_props : snabbdom_module = "default" [@@bs.module "snabbdom/modules/props"]

(* Prop module *)
let prop key (value:string) = set_data_path [|"props"; key|] value
