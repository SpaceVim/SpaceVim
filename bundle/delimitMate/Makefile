PLUGIN   =  $(wildcard plugin/*.vim)
SOURCES  =  $(PLUGIN)
LIB      =  $(wildcard autoload/*.vim)
SOURCES  += $(LIB)
DOC      =  $(wildcard doc/*.txt)
SOURCES  += $(DOC)
NAME     =  delimitMate
VERSION  =  $(shell $(SED) -n -e '/Current \+release/{s/^ \+\([0-9.]\+\).*/\1/;p;}' $(firstword $(DOC)))
FILENAME =  $(NAME)-$(VERSION)
DESTDIR  =  $(HOME)/.vim
VIM      =  vim
SED      =  $(shell command -v gsed || command -v sed)
PERL     =  perl
comma    := ,
empty    :=
space    := $(empty) $(empty)

.PHONY: version clean distclean undo release test install uninstall

all: zip gzip
dist: version all
vimball: $(FILENAME).vmb
zip: $(FILENAME).zip $(FILENAME).vmb.zip
gzip: $(FILENAME).tar.gz $(FILENAME).vmb.gz

clean:
	rm -f */*.orig *.~* .VimballRecord *.zip *.gz *.vmb

distclean: clean
	-zsh -c 'setopt extendedglob; rm -f ^(README.md|Makefile|basic_vimrc)(.)'
	-zsh -c 'setopt extendedglob; rm -f .^(git|README.md|Makefile|basic_vimrc)*'

undo:
	for i in */*.orig; do mv -f "$$i" "$${i%.*}"; done

version:
	$(PERL) -i.orig -pne 'if (/^"\sVersion:/) {s/(\d+\.\S+)/$(VERSION)/}' $(PLUGIN) $(LIB)
	$(PERL) -i.orig -pne \
	  'if (/let\sdelimitMate_version/) {s/"(\d+\.\S+)"/"$(VERSION)"/}' $(PLUGIN)
	$(PERL) -i.orig -pne 'if (/beasts/) {s/(v\d+\.\S+)/v$(VERSION)/}' $(DOC)
	$(PERL) -i.orig -MPOSIX -pne \
	  'if (/^"\sModified:/) {$$now_string = strftime "%F", localtime; s/(\d+-\d+-\d+)/$$now_string/e}' \
	  $(PLUGIN) $(LIB)
	$(PERL) -i.orig -MPOSIX -pne \
	  'if (/^\s+$(VERSION)\s+\d+-\d+-\d+\s+\*/) {$$now_string = strftime "%F", localtime; s/(\d+-\d+-\d+)/$$now_string/}' \
	  $(DOC)

test:
	$(MAKE) -C test

install: $(SOURCES)
	for dir in $(^D);\
  do install -d -m 0755 $(DESTDIR)$(PREFIX)/$$dir;\
done;\
for file in $^;\
  do install -m 0644 $$file $(DESTDIR)$(PREFIX)/$$file;\
done;

uninstall:
	for file in $(SOURCES);\
  do rm -f $(DESTDIR)$(PREFIX)/$$file;\
done;

%.vmb: $(SOURCES)
	$(VIM) -N -es -u NORC \
  -c 'call setline(1,["$(subst $(space),"$(comma)",$^)"])'\
  -c "%MkVimball! $(basename $@) ." -c 'q!'

%.vmb.zip: vimball
	zip $@ $(basename $@)

%.zip: $(SOURCES)
	zip $@ $^

%.vmb.gz: vimball
	gzip -f < $(basename $@) > $@

%.tar.gz: $(SOURCES)
	tar -cvzf $@ $^

# vim:ts=2:sw=2
