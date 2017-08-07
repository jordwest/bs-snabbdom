module Data = Snabbdom_data

type t = <
    sel: string Js.undefined;
    data: Data.t;
    children: t array Js.undefined;
    elm: Dom.element Js.undefined;
    text: string Js.undefined;
    key: string Js.undefined;
> Js.t

type transformer = t -> t

let empty () : t =
    [%bs.obj {
        sel = Js.undefined;
        data = Data.empty ();
        children = Js.undefined;
        elm = Js.undefined;
        text = Js.undefined;
        key = Js.undefined;
    }]

external unsafe_set_children : t -> 'a -> unit = "children" [@@bs.set]

external set_sel : t -> string -> unit = "sel" [@@bs.set]
external set_data : t -> Data.t -> unit = "data" [@@bs.set]
external set_children : t -> t array -> unit = "children" [@@bs.set]
external set_text : t -> string -> unit = "text" [@@bs.set]
external set_key : t -> string -> unit = "key" [@@bs.set]
let clear_text vnode = unsafe_set_children vnode Js.undefined;

external unsafe_get_data : t -> Data.t = "data" [@@bs.get]
external get_children : t -> t array option = "children" [@@bs.get] [@@bs.return null_undefined_to_opt]
external get_elm : t -> Dom.element option = "elm" [@@bs.get] [@@bs.return null_undefined_to_opt]
external get_text : t -> string option = "text" [@@bs.get] [@@bs.return null_undefined_to_opt]
external of_dom_element : Dom.element -> t = "%identity"

let set_in_data path value vnode =
    set_data vnode (Data.set_in_path (unsafe_get_data vnode) path value);
    vnode

exception Element_with_id_not_found of string
let from_dom_id dom_id =
    match (Snabbdom_dom.get_element_by_id Snabbdom_dom.document dom_id) with
        | None -> raise (Element_with_id_not_found dom_id)
        | Some x -> (of_dom_element x)
