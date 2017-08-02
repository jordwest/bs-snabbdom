(* Contains the external Snabbdom bindings *)


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
    type t

    external get_elm : t -> Dom.element = "elm" [@@bs.get]
    external of_dom_element : Dom.element -> t = "%identity"
end

type patchfn = VNode.t -> VNode.t -> unit
type snabbdom_module

external h : string -> Data.t -> VNode.t array -> VNode.t = "h" [@@bs.module "snabbdom"]
external h_text : string -> Data.t -> string -> VNode.t = "h" [@@bs.module "snabbdom"]

external init : snabbdom_module array -> patchfn = "init" [@@bs.module "snabbdom"]

(* Bindings to some standard DOM functions. Some of these might be implemented in the Bucklescript,
   standard libraries, at which point they can be removed from here. *)
module Dom = struct
    external focus : Dom.element -> unit = "focus" [@@bs.send]
    external document : Dom.document = "" [@@bs.val]
    external get_element_by_id : Dom.document -> string -> Dom.element option = "getElementById" [@@bs.send] [@@bs.return null_to_opt]

    external stop_propagation : 'a Dom.event_like -> unit = "stopPropagation" [@@bs.send]
    external prevent_default : 'a Dom.event_like -> unit = "preventDefault" [@@bs.send]
    external get_target : 'a Dom.event_like -> 'a Dom.eventTarget_like = "target" [@@bs.get]

    external get_value :'a Dom.eventTarget_like -> string = "value" [@@bs.get]
    external is_checked : 'a Dom.eventTarget_like -> bool = "checked" [@@bs.get]

    external set_timeout : (unit -> unit) -> int -> int = "setTimeout" [@@bs.val]
end
