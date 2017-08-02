
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

let children (new_children:Ex.VNode.t list) ((data, children, text):node_params) : node_params =
    (data, children @ new_children, text)
let text new_text ((data, children, _):node_params) : node_params =
    (data, children, Some new_text)
let key (key:string) = set_data_path [|"key"|] key
let nothing (a:node_params) = a 

(* Attribute module *)
external module_attributes : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/attributes"]
let attr key (value:string) = set_data_path [|"attrs"; key|] value

(* Class module *)
external module_class : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/class"]
let class_name key = set_data_path [|"class"; key|] Js.true_

(* Style module *)
external module_style : Ex.snabbdom_module = "default" [@@bs.module "snabbdom/modules/style"]
let style style_attr (value:string) = set_data_path [|"style"; style_attr|] value
let style_delayed style_attr (value:string) = set_data_path [|"style"; "delayed"; style_attr|] value
let style_remove style_attr (value:string) = set_data_path [|"style"; "remove"; style_attr|] value
