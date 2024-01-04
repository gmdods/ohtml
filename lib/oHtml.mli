type t

(* Lift string into managed HTML *)
val html : string -> t

(* Lower HTML into string *)
val print : t -> string

module Attr : sig
  (* Generate a new attribute *)
  val attr : string -> string -> string

  (* Generate a list of classes *)
  val classes : string list -> string

  (* Generate a list of classes *)
  val styles : (string * string) list -> string
end

(* Create an enclosed HTML tag *)
val tag : string -> ?attr:string -> t list -> t

type regular =
  ?id:string
  -> ?classes:string list
  -> ?styles:(string * string) list
  -> t list
  -> t

(* Create an enclosed HTML tag *)
val regular_tag : string -> ?attr:string -> regular

(* Create `a` tag *)
val a : ?href:string -> regular

(* Create `div` tag *)
val div : regular

(* Create `p tag *)
val p : regular
