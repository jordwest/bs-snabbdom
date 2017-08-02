(** Main snabbdom functions *)

(** This snabbdom function is not supported *)
exception Not_supported

(** A node cannot have both text and child nodes *)
exception Children_not_allowed_with_text

(** The submodule type refers to a Snabbdom Module. Any of the
    modules (defined below) can be passed to `init` to create a
    patching function.
    
    {{:https://github.com/snabbdom/snabbdom#modules-documentation} See the Snabbdom documentation for details on modules}

    If you've built a custom module, you can define it using:
    {[external my_module : submodule = "default" \[\@\@bs.module "path/to/module"\]]}
    *)
type submodule

val module_props : submodule
val module_eventlisteners : submodule
val module_style : submodule
val module_class : submodule
val module_attributes : submodule

(** A Snabbdom patch function (returned by `init`) which takes an old
    DOM element or vnode and patches it to match a new vnode
    *)
type patchfn = Snabbdom_external.vnode -> Snabbdom_external.vnode -> unit

type data
type node_params = ( data * Snabbdom_external.vnode array * string option )
type node_params_transformer = node_params -> node_params

(** The recommended function for creating Snabbdom vnodes.
    {{:https://github.com/snabbdom/snabbdom#snabbdomh} Snabbdom documentation}
    *)
val h : string -> node_params_transformer list -> Snabbdom_external.vnode

(** Create a new Snabbdom patch function from an array of modules
    *)
val init : submodule array -> patchfn

(** Handy reference to the global `document` element *)
val document : Dom.document

(** Use a DOM element as a vnode. This doesn't do anything but satisfy the type checker *)
val vnode_of_dom : Dom.element -> Snabbdom_external.vnode

(** External binding to the `document.getElementById` function *)
val get_element_by_id : Dom.document -> string -> Dom.element option
