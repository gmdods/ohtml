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

  (* Encodes a list of classes *)
  type classes = string list

  (* Generate a list of classes *)
  val classes : string list -> string

  (* Encoding a list key-value pair of styles *)
  type styles = (string * string) list

  (* Generate a list of styles *)
  val styles : (string * string) list -> string
end

(* Create an enclosed HTML tag *)
val tag : string -> ?attr:string -> t list -> t

type regular =
  ?id:string -> ?classes:Attr.classes -> ?styles:Attr.styles -> t list -> t

(* Create an enclosed HTML tag *)
val regular_tag : string -> ?attr:string -> regular

(* Create `a` tag *)
val a : ?href:string -> regular

(* Create `div` tag *)
val div : regular

(* Create `p tag *)
val p : regular
