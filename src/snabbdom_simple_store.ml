(**
  * This is not actually part of Snabbdom. It's a simple
  * Redux-like store that can optional be used easily with Snabbdom.
  *)

type ('state, 'action) t = {
    mutable state: 'state;
    mutable on_change: (('state, 'action) t -> unit) list;
    reducer: 'state -> 'action -> 'state;
    dispatcher: (('state, 'action) t -> ('action -> unit) -> 'action -> unit) option;
}

let get_state store = store.state

let reduce_and_update_store store action =
    let new_state = store.reducer (get_state store) action in
    store.state <- new_state;
    List.iter (fun(cb) -> cb store) store.on_change

let dispatch store action =
    match store.dispatcher with
        | None -> (reduce_and_update_store store action)
        | Some middleware -> middleware store (reduce_and_update_store store) action

(* Add a new listener to be called when the store changes *)
let on_change store callback =
    store.on_change <- List.append store.on_change [callback]

let create_store initial_state reducer =
    {
        state = initial_state;
        dispatcher = None;
        reducer = reducer;
        on_change = [];
    }

let create_store_with_middleware initial_state reducer middleware =
    {
        state = initial_state;
        reducer = reducer;
        dispatcher = Some middleware;
        on_change = [];
    }
