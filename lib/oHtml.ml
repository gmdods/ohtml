type t = HTML of string

let html str = HTML str
let print (HTML str) = str

(* Wrapping String functions *)
let cat (HTML lhs) (HTML rhs) = HTML (String.cat lhs rhs)
let concat = List.fold_left cat (HTML "")

module Attr = struct
  type t = string * string

  let attr (label, attribute) = " " ^ label ^ "=\"" ^ attribute ^ "\""
  let concat = List.fold_left (fun s a -> s ^ attr a) ""

  let opt_attr label = function
    | None -> ""
    | Some attribute -> attr (label, attribute)
  ;;

  let list_attr label ~join = function
    | [] -> ""
    | attributes -> attr (label, join attributes)
  ;;

  let bool_attr label = function
    | false -> ""
    | true -> " " ^ label
  ;;

  let classes = list_attr "class" ~join:(String.concat " ")

  type style = string * string

  let styles =
    let css (k, v) = k ^ ": " ^ v ^ ";" in
    list_attr "style" ~join:(List.fold_left (fun s kv -> s ^ css kv) "")
  ;;
end

type element = ?attrs:Attr.t list -> t list -> t

let element tag ~prop ?(attrs = []) inner =
  let (HTML inner) = concat inner in
  let attrs = prop ^ Attr.concat attrs in
  html @@ "<" ^ tag ^ attrs ^ ">" ^ inner ^ "</" ^ tag ^ ">"
;;

type regular =
  ?id:string
  -> ?title:string
  -> ?hidden:bool
  -> ?classes:string list
  -> ?styles:Attr.style list
  -> element

let regular_tag
  tag
  ~prop
  ?id
  ?title
  ?(hidden = false)
  ?(classes = [])
  ?(styles = [])
  =
  let prop =
    prop
    ^ Attr.opt_attr "id" id
    ^ Attr.opt_attr "title" title
    ^ Attr.bool_attr "hidden" hidden
    ^ Attr.classes classes
    ^ Attr.styles styles
  in
  element tag ~prop
;;

let a ?href = regular_tag "a" ~prop:(Attr.opt_attr "href" href)
let div = regular_tag "div" ~prop:""
let p = regular_tag "p" ~prop:""
let button = regular_tag "button" ~prop:""

let%test "div" =
  div [ p [ html "Hello" ]; p [ html "World" ]; p ~hidden:true [ html "!" ] ]
  = html @@ "<div>" ^ "<p>Hello</p><p>World</p><p hidden>!</p>" ^ "</div>"
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

let%test "button" =
  button ~classes:[ "click" ] [ html "Click" ] ~attrs:[ "onclick", "add(this)" ]
  = html
    @@ "<button class=\"click\" onclick=\"add(this)\">"
    ^ "Click"
    ^ "</button>"
;;
