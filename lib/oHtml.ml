type t = HTML of string

let html str = HTML str
let print (HTML str) = str

(* Wrapping String functions *)
let cat (HTML lhs) (HTML rhs) = HTML (String.cat lhs rhs)
let concat = List.fold_left cat (HTML "")

module Attr = struct
  let as_string fn = function
    | "" -> ""
    | full -> fn full
  ;;

  let as_list fn = function
    | [] -> ""
    | full -> fn full
  ;;

  let attr attr = as_string (fun str -> " " ^ attr ^ "=\"" ^ str ^ "\"")
  let classes = as_list (fun c -> attr "class" @@ String.concat " " c)

  let styles =
    as_list (fun c ->
      attr "style"
      @@ String.concat ""
      @@ List.map (fun (k, v) -> k ^ ": " ^ v ^ ";") c)
  ;;
end

let tag tags ?(attr = "") inner =
  let (HTML inner) = concat inner in
  let attr = Attr.as_string Fun.id attr in
  html @@ "<" ^ tags ^ attr ^ ">" ^ inner ^ "</" ^ tags ^ ">"
;;

type regular =
  ?id:string
  -> ?classes:string list
  -> ?styles:(string * string) list
  -> t list
  -> t

let regular_tag tags ?(attr = "") ?(id = "") ?(classes = []) ?(styles = []) =
  let regulars =
    Attr.attr "id" id ^ Attr.classes classes ^ Attr.styles styles
  in
  tag tags ~attr:(attr ^ regulars)
;;

let a ?(href = "") = regular_tag "a" ~attr:(Attr.attr "href" href)
let div = regular_tag "div" ~attr:""
let p = regular_tag "p" ~attr:""

let%test "div, styles" =
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
