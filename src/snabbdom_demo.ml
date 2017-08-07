open Snabbdom.Base
open Snabbdom.Props
open Snabbdom.Events
open Snabbdom.Dom
module Store = Snabbdom.Simple_store

let patch = init [|
    module_props;
    module_attributes;
    module_eventlisteners;
    module_style;
|]

type action =
    | Increment
    | Decrement
    | SetText of string
    | AddItem
    | Delete of string
    | ToggleShow of bool

type state = {
    count: int;
    name: string;
    items: string list;
    show_items: bool;
}

let rec many_items items i max =
    match i with
        | _ when i >= max -> items
        | _ ->
            many_items (List.append [ "Item " ^ string_of_int i ] items) (i+1) max

let checkbox (checked:bool) onCheck (label_text:string) =
    h "label"
        [ children
            [ h "input"
                [ change onCheck
                ; prop "type" "checkbox"
                ; prop "checked" (if checked then "checked" else "")
                ]
            ; h "span" [style "font-weight" "bold"; text label_text];
            ]
        ]

let item store s =
    let del _ =
        Store.dispatch store (Delete s)
    in

    h "tr" [
        key s;
        style "line-height" "0";
        style "opacity" "1";
        style "transition" "line-height 0.3s, opacity 0.3s";
        style_delayed "line-height" "1";
        style_remove "line-height" "0";
        style_remove "opacity" "0";
        children [
            h "td" [children [
                h "a" [
                    prop "href" "javascript:;";
                    mousemove del;
                    text s
                ]
            ]]
    ]]

let view store =
    let state = Store.get_state store in

    let cb action ev =
        prevent_default ev;
        stop_propagation ev;
        Store.dispatch store action
    in

    let onChange ev = next_tick (fun () ->
        let value = (ev |> get_target |> get_value) in
        Store.dispatch store (SetText value)
    ) in

    let onCheck ev =
        let value = (ev |> get_target |> is_checked ) in
        Store.dispatch store (ToggleShow value)
    in

    h "div" [
        children [
            h "h1" [text ("Count: " ^ string_of_int state.count)];
            h "button" [ click (cb Increment); text "+" ];
            h "button" [ click (cb Decrement); text "-" ];
            h "p" [
                children [h "strong" [text "bs-snabbdom"]];
                text " demo. ";
                children [h "em" [text state.name]];
            ];
            h "div" [children [
                h "input" [
                    keydown onChange;
                    prop "placeholder" "Type something, click Add";
                    prop "value" state.name;
                ];
                h "button" [ click (cb AddItem); text "Add" ];
            ]];
            checkbox state.show_items onCheck "Show item list";
            h "svg" [attr "width" "200"; attr "height" "200"; children [
                h "circle" [attr "cx" "50"; attr "cy" "50"; attr "r" "30"; attr "fill" "#000"];
            ]]
        ];
        if state.show_items then
            children [ h "table" [
                children [h "tr" [children [
                    h "td" [text "Mouse over to delete"]
                ]]];
                prop "border" "1";
                children (List.map (item store) state.items)
            ] ]
        else
            nothing
    ]

exception No_root_element

let vnode = ref (Snabbdom.VNode.from_dom_id "app")

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
        show_items = false;
    } reducer logging_middleware in
    Store.on_change store (render view);
    render view store;
    ()

let _ = main ()
