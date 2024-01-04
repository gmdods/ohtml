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
end

let tag tag ?(attr = "") inner =
  let (HTML inner) = concat inner in
  let attr = Attr.as_string Fun.id attr in
  html @@ "<" ^ tag ^ attr ^ ">" ^ inner ^ "</" ^ tag ^ ">"
;;

let a ?(href = "") ?(classes = []) =
  tag "a" ~attr:(Attr.attr "href" href ^ Attr.classes classes)
;;

let div ?(classes = []) = tag "div" ~attr:(Attr.classes classes)

let%test "div" =
  div
    ~classes:[ "great"; "awesome" ]
    [ div [ html "Hello" ]; div [ html "World" ] ]
  = html
    @@ "<div class=\"great awesome\">"
    ^ "<div>Hello</div>"
    ^ "<div>World</div>"
    ^ "</div>"
;;

let%test "a" =
  a ~href:"https://ocaml.org" ~classes:[ "link" ] [ html "Link" ]
  = html @@ "<a href=\"https://ocaml.org\" class=\"link\">" ^ "Link" ^ "</a>"
;;
