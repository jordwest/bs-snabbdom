
(* Use the external Snabbdom bindings via Ex *)
module Ex = Snabbdom_external

exception Not_supported

type vnode = Ex.VNode.t

(* ==== Transformers ====  *)
(* General *)
let set_data_path path value vnode : vnode =
    Ex.VNode.set_in_path vnode (Array.append [|"data"|] path) value

let namespace = set_data_path [|"ns"|]

type vnode_transformer = vnode -> vnode

let rec recursively_set_namespace ns (vnode : vnode) : vnode =
    let vnode = namespace ns vnode in
    let _ = (match Ex.VNode.get_children vnode with
        | Some children -> Array.map (recursively_set_namespace ns) children
        | None -> [||]
    ) in
    vnode

let h selector (transformers: vnode_transformer list) =
    (* Start with a blank vnode *)
    let vnode = Ex.VNode.empty () in
    Ex.VNode.set_data vnode (Ex.Data.empty ());
    Ex.VNode.set_sel vnode selector;

    (* Now run through all the transformers provided to set up the vnode *)
    let transform (vnode:vnode) (transformer:vnode_transformer) =
        transformer vnode in
    let vnode = List.fold_left transform vnode transformers in

    (* Need to know if the node is an SVG so we can add the XML namespace *)
    let is_svg = (match String.length selector with
        | len when len == 3 -> selector == "svg"
        | len when len >= 4 -> (match String.sub selector 0 4 with
            | "svg#" -> true
            | "svg." -> true
            | _ -> false
        )
        | _ -> false
    ) in
    if is_svg then
        recursively_set_namespace "http://www.w3.org/2000/svg" vnode
    else
        vnode

let text_vnode t =
    let node = Ex.VNode.empty () in
    Ex.VNode.set_text node t;
    node

let children (new_children:vnode list) vnode : vnode =
    (match (Ex.VNode.get_children vnode, Ex.VNode.get_text vnode) with
        | (None, Some t) ->
            Ex.VNode.clear_text vnode;
            Ex.VNode.set_children vnode (Array.of_list ([text_vnode t] @ new_children));
        | (Some children, None) ->
            Ex.VNode.set_children vnode (Array.append children (Array.of_list new_children));
        | (None, None) ->
            Ex.VNode.set_children vnode (Array.of_list new_children);
        | _ -> raise Not_supported
    );
    vnode

 let text new_text vnode : vnode =
    (match (Ex.VNode.get_children vnode) with
        | Some children ->
            Ex.VNode.set_children vnode (Array.append children [|text_vnode new_text|]);
        | None ->
            Ex.VNode.set_text vnode new_text;
    );
    vnode

let key (key:string) vnode =
    Ex.VNode.set_key vnode key;
    vnode

let nothing (a:vnode) = a 

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
