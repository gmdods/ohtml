type t = HTML of string

let html str = HTML str
let print (HTML str) = str

module Html = struct
  let cat (HTML lhs) (HTML rhs) = HTML (String.cat lhs rhs)
  let concat = List.fold_left cat (HTML "")

  let non_empty fn = function
    | "" -> ""
    | full -> fn full
  ;;

  let non_nil fn = function
    | [] -> ""
    | full -> fn full
  ;;
end

let tag tag ?(attr = "") inner =
  let (HTML inner) = Html.concat inner in
  let attr = Html.non_empty (( ^ ) " ") attr in
  html @@ "<" ^ tag ^ attr ^ ">" ^ inner ^ "</" ^ tag ^ ">"
;;

let a ?(href = "") ?(classes = []) =
  tag
    "div"
    ~attr:
      (Html.non_empty (fun h -> "href=\"" ^ h ^ "\"") href
       ^ Html.non_nil (fun c -> "class=\"" ^ String.concat " " c ^ "\"")
       @@ classes)
;;

let div ?(classes = []) =
  tag
    "div"
    ~attr:
      (Html.non_nil (fun c -> "class=\"" ^ String.concat " " c ^ "\"") classes)
;;

let%test "div" =
  div ~classes:[ "great" ] [ div [ html "Hello" ]; div [ html "World" ] ]
  = html
    @@ "<div class=\"great\">"
    ^ "<div>Hello</div>"
    ^ "<div>World</div>"
    ^ "</div>"
;;
