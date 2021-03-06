// Generated by BUCKLESCRIPT VERSION 4.0.5, PLEASE EDIT WITH CARE
'use strict';

var Snabbdom_dom = require("./snabbdom_dom.js");
var Snabbdom_vnode = require("./snabbdom_vnode.js");

function next_tick(cb) {
  Snabbdom_dom.set_timeout(cb, 0);
  return /* () */0;
}

function event_listener(key, cb) {
  var partial_arg = /* array */[
    "on",
    key
  ];
  return (function (param) {
      return Snabbdom_vnode.set_in_data(partial_arg, cb, param);
    });
}

var $$event = event_listener;

function change(param) {
  return event_listener("change", param);
}

var mouse = event_listener;

function click(param) {
  return event_listener("click", param);
}

function mousedown(param) {
  return event_listener("mousedown", param);
}

function mouseup(param) {
  return event_listener("mouseup", param);
}

function mousemove(param) {
  return event_listener("mousemove", param);
}

var keyboard = event_listener;

function keydown(param) {
  return event_listener("keydown", param);
}

function keyup(param) {
  return event_listener("keyup", param);
}

function keypress(param) {
  return event_listener("keypress", param);
}

var drag = event_listener;

function dragenter(param) {
  return event_listener("dragenter", param);
}

function dragover(param) {
  return event_listener("dragover", param);
}

function dragleave(param) {
  return event_listener("dragleave", param);
}

function drop(param) {
  return event_listener("drop", param);
}

var VNode = 0;

exports.VNode = VNode;
exports.next_tick = next_tick;
exports.event_listener = event_listener;
exports.$$event = $$event;
exports.change = change;
exports.mouse = mouse;
exports.click = click;
exports.mousedown = mousedown;
exports.mouseup = mouseup;
exports.mousemove = mousemove;
exports.keyboard = keyboard;
exports.keydown = keydown;
exports.keyup = keyup;
exports.keypress = keypress;
exports.drag = drag;
exports.dragenter = dragenter;
exports.dragover = dragover;
exports.dragleave = dragleave;
exports.drop = drop;
/* Snabbdom_dom Not a pure module */
