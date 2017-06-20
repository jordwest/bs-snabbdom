(**
  * This is not actually part of Snabbdom. It's a simple
  * Redux-like store that can optional be used easily with Snabbdom.
  *)

type ('state, 'action) t = {
    mutable state: 'state;
    mutable dispatcher: ('state, 'action) t -> 'action -> unit;
    mutable on_change: (('state, 'action) t -> unit) list;
}

let get_state store = store.state
let dispatch store action =
    store.dispatcher store action

(* Add a new listener to be called when the store changes *)
let on_change store callback =
    store.on_change <- List.append store.on_change [callback]

let reduce_and_update_store reducer store action =
    let new_state = reducer (get_state store) action in
    store.state <- new_state;
    List.iter (fun(cb) -> cb store) store.on_change

let create_store initial_state reducer =
    {
        state = initial_state;
        dispatcher = reduce_and_update_store reducer;
        on_change = [];
    }

let create_store_with_middleware initial_state reducer middleware =
    {
        state = initial_state;
        dispatcher = middleware (reduce_and_update_store reducer);
        on_change = [];
    }
