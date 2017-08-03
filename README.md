Bucklescript + Snabbdom
=======================

These are *experimental and incomplete* bindings to [Snabbdom](https://github.com/snabbdom/snabbdom) for [Bucklescript](https://github.com/OvermindDL1/bucklescript-tea).

[API Documentation](https://jordwest.github.io/bs-snabbdom/)

## Why 

[Snabbdom](https://github.com/snabbdom/snabbdom) is a small, fast, functional and extensible virtual DOM library that meshes really well with OCaml. Using something like Snabbdom in OCaml can bring you the best parts of languages like Elm plus a tiny bundle size, without a complete architectural overhaul.

If you're already working on a Snabbdom project in JavaScript, you can use these bindings to introduce OCaml for safer types and less runtime errors. Snabbdom components are just functions which return vnodes, so they're totally interchangeable between JavaScript and Bucklescript.

This project was inspired by [bucklescript-tea](https://github.com/OvermindDL1/bucklescript-tea), which provides an almost drop-in replacement of Elm for Bucklescript. I wanted something that provided a functional, type-safe declarative UI language, without adopting the entire Elm architecture. In contrast to Elm and bucklescript-tea, Snabbdom (and `bs-snabbdom`) does not provide a data model so you'll need to bring your own.

## Introduction

This project adds basic OCaml bindings for Snabbdom functions, as well as a thin layer over Snabbdom's `h` function to make the API more OCaml friendly and statically typed.

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
h : string -> node_params_transformer list -> vnode
```

The first parameter - the element selector (eg: `"ul.my-list"`) - remains the same.

The second parameter takes a list of transformer functions. These transformers describe how to alter the `data`, `children` and `text` parameters before they're passed to Snabbdom's `h` function.

This is because OCaml generally does not support multiple function signatures, so in bs-snabbdom we simplify by combining the `data`, `children` and `text` parameters into a single array that describes how to construct them.

