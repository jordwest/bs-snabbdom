open Snabbdom.Base
open Snabbdom.Props
module Events = Snabbdom.Events
module Store = Snabbdom.Simple_store

let patch = Snabbdom_external.init [|
    module_props;
    module_eventlisteners;
    module_style;
|]

type action =
    | Increment
    | Decrement
    | SetText of string
    | AddItem
    | Delete of string
    | DragStart
    | DragEnd
    | ToggleShow of bool

type state = {
    count: int;
    name: string;
    items: string list;
    dragging: bool;
    show_items: bool;
}

let rec many_items items i max =
    match i with
        | _ when i >= max -> items
        | _ ->
            many_items (List.append [ "Item " ^ string_of_int i ] items) (i+1) max

let checkbox (checked:bool) onCheck (label_text:string) =
    h "label"
        [ add_children
            [ h "input"
                [ Events.change onCheck
                ; prop "type" "checkbox"
                ; prop "checked" (if checked then "checked" else "")
                ]
            ; h "span" [set_style "font-weight" "bold"; set_text label_text];
            ]
        ]

let item store s =
    let del _ =
        Store.dispatch store (Delete s)
    in

    h "tr" [
        set_key s;
        set_style "line-height" "0";
        set_style "opacity" "1";
        set_style "transition" "line-height 0.3s, opacity 0.3s";
        set_style_delayed "line-height" "1";
        set_style_remove "line-height" "0";
        set_style_remove "opacity" "0";
        add_children [
            h "td" [add_children [
                h "a" [
                    prop "href" "javascript:;";
                    Events.mousemove del;
                    set_text s
                ]
            ]]
    ]]

let view store = 
    let state = Store.get_state store in

    let cb action ev =
        Snabbdom_external.Dom.prevent_default ev;
        Snabbdom_external.Dom.stop_propagation ev;
        Store.dispatch store action
    in

    (*let onChange (ev:Dom.keyboardEvent Dom.event_like) = Events.next_tick (fun () ->*)
    let onChange ev = Events.next_tick (fun () ->
        let value = (ev |> Snabbdom_external.Dom.get_target |> Snabbdom_external.Dom.get_value) in
        Store.dispatch store (SetText value)
    ) in

    let onCheck ev =
        let value = (ev |> Snabbdom_external.Dom.get_target |> Snabbdom_external.Dom.is_checked ) in
        Store.dispatch store (ToggleShow value)
    in

    h "div" [
        add_children [
            h "h1" [set_text ("Hello " ^ string_of_int state.count)];
            h "p" [set_text ("This is some paragraph text. " ^ state.name)];
            h "input" [
                Events.keydown onChange;
                prop "placeholder" "Some placeholder text";
                prop "value" state.name;
            ];
            h "button" [ Events.click (cb AddItem); set_text "Add" ];
            h "button" [ Events.click (cb Increment); set_text "+" ];
            h "button" [ Events.click (cb Decrement); set_text "-" ];
            checkbox state.show_items onCheck "This is some label";
        ];
        if state.show_items then
            add_children [ h "table" [
                prop "border" "1";
                add_children (List.map (item store) state.items)
            ] ]
        else
            nothing
    ]

exception No_root_element

let vnode = ref (match (Snabbdom_external.Dom.get_element_by_id Snabbdom_external.Dom.document "app") with
    | Some el -> Snabbdom_external.vnode_of_dom el
    | None -> raise No_root_element
    )

let reducer state action =
    match action with
        | Increment -> { state with count = state.count + 1 }
        | Decrement -> { state with count = state.count - 1 }
        | SetText v -> { state with name = v }
        | AddItem ->
            let item_name = state.name ^ ": " ^ string_of_int(state.count) in
            { state with
                items = List.append [ item_name ] state.items;
                name = ""
            }
        | Delete s ->
            let no_name_match item = not (item == s) in
            { state with items = List.filter no_name_match state.items }
        | DragStart -> { state with dragging = true }
        | DragEnd -> { state with dragging = false }
        | ToggleShow show -> { state with show_items = show }

let logging_middleware store next action =
    print_endline "Action:";
    Js.log action;
    next action;
    print_endline "New state:";
    Js.log (Store.get_state store)

let render view store =
    let newVnode = (view store) in
    patch !vnode newVnode;
    vnode := newVnode;
    ()

let main () =
    let store = Store.create_store_with_middleware {
        count = 0;
        name = "";
        items = many_items [] 0 500;
        dragging = false;
        show_items = false;
    } reducer logging_middleware in
    Store.on_change store (render view);
    render view store;
    ()

let _ = main ()
