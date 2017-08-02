// Generated by BUCKLESCRIPT VERSION 1.8.1, PLEASE EDIT WITH CARE
'use strict';

import * as List                                      from "bs-platform/lib/es6/list.js";
import * as $$Array                                   from "bs-platform/lib/es6/array.js";
import * as Snabbdom                                  from "snabbdom";
import * as Js_primitive                              from "bs-platform/lib/es6/js_primitive.js";
import * as Caml_exceptions                           from "bs-platform/lib/es6/caml_exceptions.js";
import * as Snabbdom$slashmodules$slashclass          from "snabbdom/modules/class";
import * as Snabbdom$slashmodules$slashprops          from "snabbdom/modules/props";
import * as Snabbdom$slashmodules$slashstyle          from "snabbdom/modules/style";
import * as Snabbdom$slashmodules$slashattributes     from "snabbdom/modules/attributes";
import * as Snabbdom$slashmodules$slasheventlisteners from "snabbdom/modules/eventlisteners";

var Not_supported = Caml_exceptions.create("Snabbdom_base.Not_supported");

var Children_not_allowed_with_text = Caml_exceptions.create("Snabbdom_base.Children_not_allowed_with_text");


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

;

function h(selector, props) {
  var snabb_props_000 = bs_snabbdom.empty_data();
  var snabb_props_001 = /* array */[];
  var snabb_props = /* tuple */[
    snabb_props_000,
    snabb_props_001,
    /* None */0
  ];
  var set_prop = function (data, param) {
    return bs_snabbdom.set_in_path(data, /* array */[
                "props",
                param[0]
              ], param[1]);
  };
  var set_attr = function (data, param) {
    return bs_snabbdom.set_in_path(data, /* array */[
                "attrs",
                param[0]
              ], param[1]);
  };
  var set_class = function (data, c) {
    return bs_snabbdom.set_in_path(data, /* array */[
                "class",
                c
              ], true);
  };
  var reducer = function (param, prop) {
    var text = param[2];
    var children = param[1];
    var data = param[0];
    if (typeof prop === "number") {
      return /* tuple */[
              data,
              children,
              text
            ];
    } else {
      switch (prop.tag | 0) {
        case 0 : 
            return /* tuple */[
                    data,
                    children,
                    /* Some */[prop[0]]
                  ];
        case 1 : 
            var match = prop[0];
            return /* tuple */[
                    bs_snabbdom.set_in_path(data, /* array */[
                          "style",
                          match[0]
                        ], match[1]),
                    children,
                    text
                  ];
        case 2 : 
            var match$1 = prop[0];
            return /* tuple */[
                    bs_snabbdom.set_in_path(data, /* array */[
                          "style",
                          "delayed",
                          match$1[0]
                        ], match$1[1]),
                    children,
                    text
                  ];
        case 3 : 
            var match$2 = prop[0];
            return /* tuple */[
                    bs_snabbdom.set_in_path(data, /* array */[
                          "style",
                          "remove",
                          match$2[0]
                        ], match$2[1]),
                    children,
                    text
                  ];
        case 4 : 
            return /* tuple */[
                    List.fold_left(set_prop, data, prop[0]),
                    children,
                    text
                  ];
        case 5 : 
            return /* tuple */[
                    set_prop(data, /* tuple */[
                          prop[0],
                          prop[1]
                        ]),
                    children,
                    text
                  ];
        case 6 : 
            return /* tuple */[
                    set_attr(data, /* tuple */[
                          prop[0],
                          prop[1]
                        ]),
                    children,
                    text
                  ];
        case 7 : 
            return /* tuple */[
                    data,
                    $$Array.append(children, $$Array.of_list(prop[0])),
                    text
                  ];
        case 8 : 
            var match$3 = prop[0];
            return /* tuple */[
                    bs_snabbdom.set_in_path(data, /* array */[
                          "on",
                          match$3[0]
                        ], match$3[1]),
                    children,
                    text
                  ];
        case 9 : 
            var match$4 = prop[0];
            var v = match$4[1];
            var k = match$4[0];
            switch (v.tag | 0) {
              case 0 : 
              case 1 : 
              case 2 : 
                  return /* tuple */[
                          bs_snabbdom.set_in_path(data, /* array */[
                                "hook",
                                k
                              ], v[0]),
                          children,
                          text
                        ];
              
            }
            break;
        case 10 : 
            return /* tuple */[
                    bs_snabbdom.set_in_path(data, /* array */["key"], prop[0]),
                    children,
                    text
                  ];
        case 11 : 
            return /* tuple */[
                    set_class(data, prop[0]),
                    children,
                    text
                  ];
        
      }
    }
  };
  var snabb_props$1 = List.fold_left(reducer, snabb_props, props);
  var children = snabb_props$1[1];
  var data = snabb_props$1[0];
  if (snabb_props$1[2]) {
    if (children.length !== 0) {
      throw Children_not_allowed_with_text;
    } else {
      return Snabbdom.h(selector, data, snabb_props$1[2][0]);
    }
  } else {
    return Snabbdom.h(selector, data, children);
  }
}

var module_props = Snabbdom$slashmodules$slashprops.default;

var module_eventlisteners = Snabbdom$slashmodules$slasheventlisteners.default;

var module_style = Snabbdom$slashmodules$slashstyle.default;

var module_class = Snabbdom$slashmodules$slashclass.default;

var module_attributes = Snabbdom$slashmodules$slashattributes.default;

function init(prim) {
  return Snabbdom.init(prim);
}

var $$document = document;

function vnode_of_dom(prim) {
  return prim;
}

function get_element_by_id(prim, prim$1) {
  return Js_primitive.null_to_opt(prim.getElementById(prim$1));
}

export {
  Not_supported                  ,
  Children_not_allowed_with_text ,
  module_props                   ,
  module_eventlisteners          ,
  module_style                   ,
  module_class                   ,
  module_attributes              ,
  h                              ,
  init                           ,
  $$document                     ,
  vnode_of_dom                   ,
  get_element_by_id              ,
  
}
/*  Not a pure module */