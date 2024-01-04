type t = HTML of string
;;
let html str = HTML str
;;
let print (HTML str) = str
;;
module Html = struct
        let cat (HTML lhs) (HTML rhs) = HTML (String.cat lhs rhs)
        ;;
        let concat = List.fold_left cat (HTML "")
        ;;
        let orelse fn = function
        | [] -> ""
        | full -> (fn full)
        ;;
end
;;
let tag tag ?(attr="") inner =
        let HTML inner = Html.concat inner in
        let attr = match attr with
        | "" -> ""
        | attr -> " " ^ attr
        in
        html @@
        "<" ^ tag ^ attr ^ ">" ^ inner  ^ "</" ^ tag ^ ">"
;;
let div ?(classes=[]) = tag "div" ~attr:(
        Html.orelse (fun c -> "class=\"" ^ String.concat " " c ^ "\"")
        classes)
;;

let%test "div" = (div ~classes:["great"]
                        [div [html "Hello"]; div [ html "World"]]) =
                html @@
                "<div class=\"great\">"^
                        "<div>Hello</div>"^
                        "<div>World</div>"^
                "</div>";;
