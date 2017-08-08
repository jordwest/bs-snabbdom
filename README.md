Bucklescript + Snabbdom
=======================

These are *experimental and incomplete* bindings to [Snabbdom](https://github.com/snabbdom/snabbdom) for [Bucklescript](http://bucklescript.github.io/bucklescript/).

[API Documentation](https://jordwest.github.io/bs-snabbdom/)

## Why

[Snabbdom](https://github.com/snabbdom/snabbdom) is a small, fast, functional and extensible virtual DOM library that meshes really well with OCaml. Using something like Snabbdom in OCaml can bring you the best parts of languages like Elm plus a tiny bundle size, without a complete architectural overhaul.

If you're already working on a Snabbdom project in JavaScript, you can use these bindings to introduce OCaml for safer types and less runtime errors. Snabbdom components are just functions which return vnodes, so they're totally interchangeable between JavaScript and Bucklescript.

This project was inspired by [bucklescript-tea](https://github.com/OvermindDL1/bucklescript-tea), which provides an almost drop-in replacement of Elm for Bucklescript. I wanted something that provided a functional, type-safe declarative UI language, without adopting the entire Elm architecture. In contrast to Elm and bucklescript-tea, Snabbdom (and `bs-snabbdom`) does not provide a data model so you'll need to bring your own.

## Introduction

This project adds basic OCaml bindings for Snabbdom functions, as well as an OCaml friendly replacement `h` function for constructing virtual dom nodes.

In JavaScript, you might write something like the following:

```js
var click_handler = function(e) {
    console.log('Clicked!', e);
}

var vnode = h('ul.my-list', {style: {'list-style': 'none'}}, [
    h('li', {on: {click: click_handler}}, 'First item')]),
    h('li', 'Second item'),
]);
```

In OCaml with bs-snabbdom, the equivalent is:

```ocaml
let click_handler e =
    Js.log2 "Clicked!" e
in

let vnode = h "ul.my-list" [style "list-style" "none"; children [
    h "li" [click click_handler; text "First item";]
    h "li" [text "Second item"];
]]
```

The main difference when compared to JavaScript is that the `h` function here always takes two arguments:

```ocaml
h : string -> vnode_transformer list -> vnode
```

The first parameter - the element selector (eg: `"ul.my-list"`) - remains the same.

The second parameter takes a list of transformer functions. These transformers describe how to alter the vnode - whether that's setting a property on the `data` object, adding children, or setting the node's text.

## Getting started

### Install Bucklescript

If you're starting from scratch, or adding bucklescript to an existing JavaScript project, you'll first need to install the Bucklescript compiler:

```sh
npm install bs-platform
./node_modules/.bin/bsb -init .
```

See the [Bucklescript docs](http://bucklescript.github.io/bucklescript/) for more details.

### Install `bs-snabbdom` and `snabbdom`

1. Install with your package manager of choice:
```sh
npm install snabbdom bs-snabbdom
```
2. Let the Bucklescript compiler know about bs-snabbdom. Add the dependency to `bsconfig.json` in your project directory:

```js
{
    /* ... */
    "bs-dependencies" : ["bs-snabbdom"],
    /* ... */
}
```

### Write some code

```ocaml
open Snabbdom.Base

(* Define a function that returns a new virtual dom node *)
let view title =
  h "div" [
    style "box-shadow" "0px 0px 10px black";
    children [
      h "h1" [text ("Hello, " ^ title ^ "!")];
      h "ol" [children [
        h "li" [text "Item 1"];
        h "li" [text "Item 2"];
        h "li" [text "Item 3"];
      ]]
    ]
  ]

(* Create a patch function from an array of Snabbdom modules *)
let patch = init [|module_style|]

(* Patch a dom element with id "#app" to the new virtual dom node *)
let () = patch (VNode.from_dom_id "app") (view "Snabbdom")
```
