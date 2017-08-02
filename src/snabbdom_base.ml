
(* Use the external Snabbdom bindings via Ex *)
module Ex = Snabbdom_external

exception Not_supported
exception Children_not_allowed_with_text

let empty_node_params () = (Ex.Data.empty (), [], None)

type node_params = ( Ex.Data.t * Ex.VNode.t list * string option )
type node_params_transformer = node_params -> node_params
let h selector (transformers: node_params_transformer list) =
    let transform (node_params:node_params) (transformer:node_params_transformer) =
        transformer node_params in
    let snabb_props = List.fold_left transform (empty_node_params ()) transformers in
    match snabb_props with
        | (data, children, None) -> Ex.h selector data (Array.of_list children)
        | (data, [], Some t) -> Ex.h_text selector data t
        | (_, _, Some _) -> raise Children_not_allowed_with_text

(* ==== Transformers ====  *)
(* General *)
let set_data_path path value ((data, children, text):node_params) : node_params =
    (Ex.Data.set_in_path data path value, children, text)
let add_children (new_children:Ex.VNode.t list) ((data, children, text):node_params) : node_params =
    (data, children @ new_children, text)
let set_text new_text ((data, children, _):node_params) : node_params =
    (data, children, Some new_text)
let set_key (key:string) = set_data_path [|"key"|] key
let nothing (a:node_params) = a 

(* Attribute module *)
let set_attr key (value:string) = set_data_path [|"attrs"; key|] value

(* Class module *)
let set_class key = set_data_path [|"class"; key|] Js.true_

(* Style module *)
let set_style style_attr (value:string) = set_data_path [|"style"; style_attr|] value
let set_style_delayed style_attr (value:string) = set_data_path [|"style"; "delayed"; style_attr|] value
let set_style_remove style_attr (value:string) = set_data_path [|"style"; "remove"; style_attr|] value

(* Hook module *)
let set_hook key cb =
    set_data_path [|"hook"; key|] cb
let set_hook0 key (cb: unit -> unit) = set_hook key cb
let set_hook1 key (cb: Ex.VNode.t -> unit) = set_hook key cb
let set_hook2 key (cb: Ex.VNode.t -> Ex.VNode.t -> unit) = set_hook key cb

(* Eventlistener module *)
let set_event_listener key cb =
    set_data_path [|"on"; key|] cb

external module_eventlisteners : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/eventlisteners"]
external module_style : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/style"]
external module_class : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/class"]
external module_attributes : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/attributes"]
