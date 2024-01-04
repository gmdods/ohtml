type t = HTML of string

let html str = HTML str
let print (HTML str) = str

(* Wrapping String functions *)
let cat (HTML lhs) (HTML rhs) = HTML (String.cat lhs rhs)
let concat = List.fold_left cat (HTML "")

module Attr = struct
  let attr attribute str = " " ^ attribute ^ "=\"" ^ str ^ "\""

  let opt_attr attribute = function
    | None -> ""
    | Some str -> attr attribute str
  ;;

  let list_attr attribute fn = function
    | [] -> ""
    | full -> attr attribute (fn full)
  ;;

  let bool_attr attribute = function
    | false -> ""
    | true -> " " ^ attribute
  ;;

  type classes = string list

  let classes = list_attr "class" (String.concat " ")

  type styles = (string * string) list

  let styles =
    let css (k, v) = k ^ ": " ^ v ^ ";" in
    list_attr "style" (List.fold_left (fun s kv -> s ^ css kv) "")
  ;;
end

let tag tags ?(attr = "") inner =
  let (HTML inner) = concat inner in
  html @@ "<" ^ tags ^ attr ^ ">" ^ inner ^ "</" ^ tags ^ ">"
;;

type regular =
  ?id:string
  -> ?title:string
  -> ?hidden:bool
  -> ?classes:Attr.classes
  -> ?styles:Attr.styles
  -> t list
  -> t

let regular_tag
  tags
  ?(attr = "")
  ?id
  ?title
  ?(hidden = false)
  ?(classes = [])
  ?(styles = [])
  =
  let regulars =
    Attr.opt_attr "id" id
    ^ Attr.opt_attr "title" title
    ^ Attr.bool_attr "hidden" hidden
    ^ Attr.classes classes
    ^ Attr.styles styles
  in
  tag tags ~attr:(attr ^ regulars)
;;

let a ?(attr = "") ?href =
  regular_tag "a" ~attr:(attr ^ Attr.opt_attr "href" href)
;;

let div ?(attr = "") = regular_tag "div" ~attr
let p ?(attr = "") = regular_tag "p" ~attr

let%test "div" =
  div [ p [ html "Hello" ]; p [ html "World" ]; p ~hidden:true [ html "!" ] ]
  = html "<div><p>Hello</p><p>World</p><p hidden>!</p></div>"
;;

let%test "styles" =
  div
    ~classes:[ "great"; "awesome" ]
    [ p [ html "Hello" ]; p ~styles:[ "color", "blue" ] [ html "World" ] ]
  = html
    @@ "<div class=\"great awesome\">"
    ^ "<p>Hello</p>"
    ^ "<p style=\"color: blue;\">World</p>"
    ^ "</div>"
;;

let%test "a" =
  a ~href:"https://ocaml.org" ~classes:[ "link" ] [ html "Link" ]
  = html @@ "<a href=\"https://ocaml.org\" class=\"link\">" ^ "Link" ^ "</a>"
;;
