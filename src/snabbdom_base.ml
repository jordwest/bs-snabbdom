
open Snabbdom_props
open Snabbdom_external

exception Not_supported
exception Children_not_allowed_with_text

(* Helper functions for manipulating Snabbdom data plain JS object *)
[%%bs.raw{|
var bs_snabbdom = {
    empty_data: function() { return {}; },
    set_in_path: function(data, path, value){
        var base = data || {};
        var ref = base;
        while(path.length > 1){
            var next = path.shift();
            ref[next] = ref[next] || {};
            ref = ref[next];
        }
        if(path.length == 1) {
            var next = path.shift();
            ref[next] = value;
        }
        return base;
    }
};
|}]

external empty_data : unit -> data = "empty_data" [@@bs.val] [@@bs.scope "bs_snabbdom"]
external set_in_path : data -> string array -> 'a -> data = "set_in_path" [@@bs.val] [@@bs.scope "bs_snabbdom"]

let h selector (props: node_info list) =
let snabb_props = (empty_data (), [||], None) in
    let set_prop data (k, v) = set_in_path data [|"props"; k|] v in
    let set_attr data (k, v) = set_in_path data [|"attrs"; k|] v in
    let set_class data (c) = set_in_path data [|"class"; c|] Js.true_ in

    let reducer (data, children, text) (prop: node_info) = match prop with
        | Text v -> (data, children, Some v)
        | Class c -> (set_class data c, children, text)
        | Children l -> (data, Array.append children (Array.of_list l), text)
        | Hook (k, v) -> (match v with
            | Zero cb -> (set_in_path data [|"hook"; k|] cb, children, text)
            | One cb -> (set_in_path data [|"hook"; k|] cb, children, text)
            | Two cb -> (set_in_path data [|"hook"; k|] cb, children, text)
        )
        | Style (k, v) -> (set_in_path data [|"style"; k|] v, children, text)
        | StyleDelay (k, v) -> (set_in_path data [|"style"; "delayed"; k|] v, children, text)
        | StyleRemove (k, v) -> (set_in_path data [|"style"; "remove"; k|] v, children, text)
        | Props l -> (List.fold_left set_prop data l, children, text)
        | Prop (k, v) -> (set_prop data (k,v), children, text)
        | Attr (k, v) -> (set_attr data (k,v), children, text)
        | EventListener (key, cb) -> (set_in_path data [|"on"; key|] cb, children, text)
        | Key v -> (set_in_path data [|"key"|] v, children, text)
        | Ignore -> (data, children, text)
    in

    let snabb_props = List.fold_left reducer snabb_props props in
    match snabb_props with
        | (data, children, None) -> _h selector data children
        | (data, [||], Some t) -> _h_text selector data t
        | (_, _, Some _) -> raise Children_not_allowed_with_text

type submodule
type patchfn = vnode -> vnode -> unit

external document : Dom.document = "" [@@bs.val]
external get_element_by_id : Dom.document -> string -> Dom.element option = "getElementById" [@@bs.send] [@@bs.return null_to_opt]
external vnode_of_dom : Dom.element -> vnode = "%identity"
external init : submodule array -> patchfn = "init" [@@bs.module "snabbdom"]

external module_props : submodule = "default" [@@bs.module "snabbdom/modules/props"]
external module_eventlisteners : submodule = "default" [@@bs.module "snabbdom/modules/eventlisteners"]
external module_style : submodule = "default" [@@bs.module "snabbdom/modules/style"]
external module_class : submodule = "default" [@@bs.module "snabbdom/modules/class"]
external module_attributes : submodule = "default" [@@bs.module "snabbdom/modules/attributes"]
