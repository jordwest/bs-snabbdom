
(* Use the external Snabbdom bindings via Ex *)
exception Not_supported
module VNode = Snabbdom_vnode
module Data = Snabbdom_data

type vnode = VNode.t
type patchfn = VNode.t -> VNode.t -> unit
type snabbdom_module

external init : snabbdom_module array -> patchfn = "init" [@@bs.module "snabbdom"]

(* ==== Transformers ====  *)
(* General *)
let namespace ns = VNode.set_in_data [|"ns"|] ns

type vnode_transformer = vnode -> vnode

let rec recursively_set_namespace ns (vnode : vnode) : unit =
    let vnode = namespace ns vnode in
    match VNode.get_children vnode with
        | Some children ->
            Array.iter (recursively_set_namespace ns) children;
        | None -> ()

let h selector (transformers: vnode_transformer list) : vnode =
    (* Start with a blank vnode *)
    let vnode = VNode.empty () in
    VNode.set_sel vnode selector;

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
     (if is_svg then (
        recursively_set_namespace "http://www.w3.org/2000/svg" vnode;
        ()
    ) else ()); 
    vnode

let text_vnode t =
    let node = VNode.empty () in
    VNode.set_text node t;
    node

let children (new_children:vnode list) vnode : vnode =
    (match (VNode.get_children vnode, VNode.get_text vnode) with
        | (None, Some t) ->
            VNode.clear_text vnode;
            VNode.set_children vnode (Array.of_list ([text_vnode t] @ new_children));
        | (Some children, None) ->
            VNode.set_children vnode (Array.append children (Array.of_list new_children));
        | (None, None) ->
            VNode.set_children vnode (Array.of_list new_children);
        | _ -> raise Not_supported
    );
    vnode

 let text new_text vnode : vnode =
    (match (VNode.get_children vnode) with
        | Some children ->
            VNode.set_children vnode (Array.append children [|text_vnode new_text|]);
        | None ->
            VNode.set_text vnode new_text;
    );
    vnode

let key (key:string) vnode =
    VNode.set_key vnode key;
    vnode

let nothing (a:vnode) = a 

(* Attribute module *)
external module_attributes : snabbdom_module = "default" [@@bs.module "snabbdom/modules/attributes"]
let attr key (value:string) = VNode.set_in_data [|"attrs"; key|] value

(* Class module *)
external module_class : snabbdom_module = "default" [@@bs.module "snabbdom/modules/class"]
let class_name key = VNode.set_in_data [|"class"; key|] true

(* Style module *)
external module_style : snabbdom_module = "default" [@@bs.module "snabbdom/modules/style"]
let style style_attr (value:string) = VNode.set_in_data [|"style"; style_attr|] value
let style_delayed style_attr (value:string) = VNode.set_in_data [|"style"; "delayed"; style_attr|] value
let style_remove style_attr (value:string) = VNode.set_in_data [|"style"; "remove"; style_attr|] value
