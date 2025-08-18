{ lib, displays, ... } :
let
  setDisplay = { workspaces, display }:
  let
    ws = builtins.map (item: item // { output = display; }) workspaces;
  in
    ws;

  names = [
    "1:browser"
    "2:term"
    "3:any"
    "4:ide"
    "5:term"
    "6:ide"
    "7:browser"
    "8:browser"
    "9:chats"
    "10:browser"
    "11:audio"
    "12:any"
  ];

  templates = builtins.genList (i: {
    workspace = builtins.elemAt names i;
    output = "";
  }) (builtins.length names);

  displayCount = builtins.length displays;
in
  if displayCount == 1 then
    setDisplay {
      workspaces = templates;
      display = builtins.elemAt displays 0;
    }
  else if displayCount == 2 then
    (setDisplay {
      workspaces = lib.lists.sublist 0 3 templates;
      display = builtins.elemAt displays 0;
    }) ++
    (setDisplay {
      workspaces = lib.lists.sublist 3 9 templates;
      display = builtins.elemAt displays 1;
    })
  else if displayCount == 3 then
    (setDisplay {
      workspaces = lib.lists.sublist 0 3 templates;
      display = builtins.elemAt displays 0;
    }) ++
    (setDisplay {
      workspaces = lib.lists.sublist 3 5 templates;
      display = builtins.elemAt displays 1;
    }) ++
    (setDisplay {
      workspaces = lib.lists.sublist 8 5 templates;
      display = builtins.elemAt displays 2;
    })
  else
    []
