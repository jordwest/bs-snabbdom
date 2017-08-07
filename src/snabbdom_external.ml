(* Contains the external Snabbdom bindings *)


(* Bindings to some standard DOM functions. Some of these might be implemented in the Bucklescript,
   standard libraries, at which point they can be removed from here. *)
module Dom = struct
    type element = Dom.element
    external focus : Dom.element -> unit = "focus" [@@bs.send]
    external document : Dom.document = "" [@@bs.val]
    external get_element_by_id : Dom.document -> string -> Dom.element option = "getElementById" [@@bs.send] [@@bs.return null_to_opt]

    external stop_propagation : 'a Dom.event_like -> unit = "stopPropagation" [@@bs.send]
    external prevent_default : 'a Dom.event_like -> unit = "preventDefault" [@@bs.send]
    external get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like = "target" [@@bs.get]

    external get_event_key : Dom.keyboardEvent -> string = "key" [@@bs.get]

    external get_value :'a Dom.eventTarget_like -> string = "value" [@@bs.get]
    external is_checked : 'a Dom.eventTarget_like -> bool = "checked" [@@bs.get]

    external set_timeout : (unit -> unit) -> int -> int = "setTimeout" [@@bs.val]
end

module Data = struct
    type t

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

    external unsafe_empty : unit -> t = "empty_data" [@@bs.val] [@@bs.scope "bs_snabbdom"]
    external unsafe_set_in_path : t -> string array -> 'a -> t = "set_in_path" [@@bs.val] [@@bs.scope "bs_snabbdom"]
    
    (* This is a hack to make sure this module and therefore the bs.raw snippet above is included
       by bundlers whenever these functions are used. *)
    let empty () = unsafe_empty ()
    let set_in_path data path value = unsafe_set_in_path data path value
end

module VNode = struct
    type t = <
        sel: string Js.undefined;
        data: Data.t Js.undefined;
        children: t array Js.undefined;
        elm: Dom.element Js.undefined;
        text: string Js.undefined;
        key: string Js.undefined;
    > Js.t

    let empty () : t =
        [%bs.obj {
            sel = Js.undefined;
            data = Js.undefined;
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

    external get_children : t -> t array option = "children" [@@bs.get] [@@bs.return null_undefined_to_opt]
    external get_elm : t -> Dom.element option = "elm" [@@bs.get] [@@bs.return null_undefined_to_opt]
    external get_text : t -> string option = "text" [@@bs.get] [@@bs.return null_undefined_to_opt]
    external of_dom_element : Dom.element -> t = "%identity"

    external unsafe_set_in_path : t -> string array -> 'a -> t = "set_in_path" [@@bs.val] [@@bs.scope "bs_snabbdom"]
    let set_in_path data path value = unsafe_set_in_path data path value

    exception Element_with_id_not_found of string
    let from_dom_id dom_id =
        match (Dom.get_element_by_id Dom.document dom_id) with
            | None -> raise (Element_with_id_not_found dom_id)
            | Some x -> (of_dom_element x)
end

type patchfn = VNode.t -> VNode.t -> unit
type snabbdom_module

external init : snabbdom_module array -> patchfn = "init" [@@bs.module "snabbdom"]
