-include user.cfg

HAVE_APRON?=true
HAVE_Z3?=true

LIBS_APRON=
PP_OPTS_APRON=
ifeq (${HAVE_APRON},true)
  LIBS_APRON=apron,apron.boxMPQ,apron.octD
  PP_OPTS_APRON=-DHAVE_APRON
endif

LIBS_Z3=
PP_OPTS_Z3=
ifeq (${HAVE_Z3},true)
  LIBS_Z3=,z3
  PP_OPTS_Z3=-DHAVE_Z3
endif

PP_OPTS=-pp "camlp4o pa_macro.cmo $(PP_OPTS_APRON) $(PP_OPTS_Z3)"

OPTS=${PP_OPTS} -cflags -warn-error,+a -use-ocamlfind -pkgs ocamlgraph,str,$(LIBS_APRON)$(LIBS_Z3)

default: kittel koat

all: kittel koat convert

kittel: make_git_sha1 force_look
	ocamlbuild ${OPTS} kittel.native

kittel.d.byte: make_git_sha1 force_look
	ocamlbuild ${OPTS} kittel.d.byte

koat: make_git_sha1 force_look
	ocamlbuild ${OPTS} koat.native

koat.d.byte: make_git_sha1 force_look
	ocamlbuild ${OPTS} koat.d.byte

convert: force_look
	ocamlbuild ${OPTS} convert.native

koatCConv: force_look
	ocamlbuild ${OPTS} koatCConv.native

koatFSTConv: force_look
	ocamlbuild ${OPTS} koatFSTConv.native

koatCESConv: force_look
	ocamlbuild ${OPTS} koatCESConv.native

clean: force_look
	ocamlbuild -clean
	rm -f git_sha1.ml

make_git_sha1: force_look
	./make_git_sha1.sh git_sha1.ml

force_look:
	@true
