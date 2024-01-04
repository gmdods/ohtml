(lang dune 3.7)

(name ohtml)

(generate_opam_files true)

(source
 (github gmdods/ohtml))

(authors "Gabriel Domingues")

(license GPL-2.0)

(package
 (name ohtml)
 (synopsis "A(nother) OCaml HTML building library")
 (description "An OCaml library for compile-time correct HTML")
 (depends ocaml dune)
 (tags
  (html)))

