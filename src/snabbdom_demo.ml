open Snabbdom.Base
module Html = Snabbdom.Html
module Events = Snabbdom.Events
module Store = Snabbdom.Simple_store

let patch = init [|
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
    Html.label
        [ Children
            [ Html.input
                [ EventListener ("change", onCheck)
                ; prop "type" "checkbox"
                ; prop "checked" (if checked then "checked" else "")
                ]
            ; Html.span [style "font-weight" "bold"; Text label_text];
            ]
        ]

let item store s =
    let del _ =
        Store.dispatch store (Delete s)
    in

    Html.h "tr" [
        Key s;
        style "line-height" "0";
        style "opacity" "1";
        style "transition" "line-height 0.3s, opacity 0.3s";
        StyleDelay ("line-height", "1");
        StyleRemove ("line-height", "0");
        StyleRemove ("opacity", "0");
        Children [
            Html.h "td" [Children [
                Html.h "a" [
                    prop "href" "javascript:;";
                    EventListener ("mousemove", del);
                    Text s
                ]
            ]]
    ]]

let view store = 
    let state = Store.get_state store in

    let cb action ev =
        Events.prevent_default ev;
        Events.stop_propagation ev;
        Store.dispatch store action
    in

    let onChange ev = Events.next_tick (fun () ->
        let value = (ev |> Events.get_target |> Events.get_value) in
        Store.dispatch store (SetText value)
    ) in

    let onCheck ev =
        let value = (ev |> Events.get_target |> Events.is_checked ) in
        Store.dispatch store (ToggleShow value)
    in

    Html.div [
        Children [
            Html.h1 [Text ("Hello " ^ string_of_int state.count)];
            Html.p [Text ("This is some paragraph text. " ^ state.name)];
            Html.input [
                EventListener ("keydown", onChange);
                prop "placeholder" "Some placeholder text";
                prop "value" state.name;
            ];
            Html.button [
                EventListener ("click", cb AddItem);
                Text "Add"
            ];
            Html.button [
                EventListener ("click", cb Increment);
                Text "+"
            ];
            Html.button [
                EventListener ("click", cb Decrement);
                Text "-"
            ];
            checkbox state.show_items onCheck "This is some label";
        ];
        if state.show_items then
            Children [ h "table" [
                prop "border" "1";
                Children (List.map (item store) state.items)
            ] ]
        else
            Ignore
    ]

exception No_root_element

let vnode = ref (match (get_element_by_id document "app") with
    | Some el -> vnode_of_dom el
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
