type t

(* Lift string into managed HTML *)
val html : string -> t

(* Lower HTML into string *)
val print : t -> string

module Attr : sig
  (* Generate a new attribute *)
  val attr : string -> string -> string
  val opt_attr : string -> string option -> string
  val list_attr : string -> ('a list -> string) -> 'a list -> string
  val bool_attr : string -> bool -> string

  (* Generate a list of classes *)
  val classes : string list -> string

  (* Encoding a key-value CSS pair *)
  type style = string * string

  (* Generate a list of styles *)
  val styles : style list -> string
end

type element = ?attr:string -> t list -> t

(* Create an enclosed HTML tag *)
val element : string -> prop:string -> element

type regular =
  ?id:string
  -> ?title:string
  -> ?hidden:bool
  -> ?classes:string list
  -> ?styles:Attr.style list
  -> element

(* Create an enclosed HTML tag *)
val regular_tag : string -> prop:string -> regular

(* Create `a` tag *)
val a : ?href:string -> regular

(* Create `div` tag *)
val div : regular

(* Create `p tag *)
val p : regular
