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
end

(* Create an enclosed HTML tag *)
val tag : string -> ?attr:string -> t list -> t

(* Create `a` tag *)
val a : ?href:string -> ?classes:string list -> t list -> t

(* Create `div` tag *)
val div : ?classes:string list -> t list -> t
