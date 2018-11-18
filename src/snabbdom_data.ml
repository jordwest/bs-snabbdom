
type t

type data_val

external to_data_val : 'a -> data_val = "%identity"
external raw_empty : unit -> t = "" [@@bs.obj]

let raw_set_in_path : t -> string array -> data_val -> t = [%bs.raw{|
function(data, path, value){
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
|}]

let empty () = raw_empty ()
let set_in_path data path value = raw_set_in_path data path (to_data_val value)
