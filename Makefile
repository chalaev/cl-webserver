SBCL = ~/local/bin/sbcl
# SBCL = /usr/bin/sbcl --core /usr/lib/sbcl/sbcl.core

quicklispDir = $$HOME/quicklisp/local-projects/web-server
stretchQL = $$HOME/ql.stretch/local-projects/web-server
# ← for (binary) compilation in chroot-ed environment;

headersDir = generated/headers

LFNs = files web-server
LISPs = $(addsuffix .lisp, $(LFNs))
package = web-server.asd description.org version.org $(LISPs) 

OFNs = web-server packaging websites
ORGs = $(addsuffix .org, $(OFNs))

all: quicklisp README.md $(addprefix generated/from/, $(ORGs)) $(quicklispDir)/binary
	rsync -au $(quicklispDir)/*.org $(quicklispDir)/*.asd $(quicklispDir)/*.lisp $(stretchQL)

quicklisp: $(quicklispDir)/ $(addprefix $(quicklispDir)/, $(package)) $(addprefix generated/from/, $(ORGs))

$(quicklispDir)/binary: quicklisp version.org
	@echo "*** COMPILING THE BINARY ***"
	$(SBCL) --quit --eval "(asdf:make :web-server)"
	@echo "*** COMPILED THE BINARY ***"
	@echo "Now run it to see the log messages both in terminal and in the log file"

$(quicklispDir)/%.asd: generated/from/packaging.org
	cat generated/$(notdir $@) > $@
	-@chgrp tmp $@

# cat generated/headers/web-server.lisp generated/web-server.lisp > $HOME/quicklisp/local-projects/web-server/web-server.lisp
$(quicklispDir)/%.lisp: generated/from/websites.org generated/from/packaging.org generated/from/web-server.org
	cat generated/headers/$(notdir $@) generated/$(notdir $@) > $@
	-@chgrp tmp $@

generated/from/%.org: %.org generated/from/ generated/headers/
	echo `emacsclient -e '(printangle "$<")'` | sed 's/"//g' > $@
	-@chgrp tmp $@ `cat $@`
	-@chmod a-x `cat $@`

README.md: README.org
	emacsclient -e '(progn (find-file "README.org") (org-md-export-to-markdown))'
	sed -i "s/\.md)/.org)/g"  $@
	-@chgrp tmp $@
	-@chmod a-x $@

clean:
	-$(SBCL) --quit --eval '(progn (asdf:clear-system :web-server) (asdf:clear-system :web-server/server)  (asdf:clear-system :web-server/tests))'
	-rm -r $(quicklispDir) generated version.org

.PHONY: clean quicklisp all

%/:
	[ -d $@ ] || mkdir -p $@

version.org: change-log.org helpers/derive-version.el
	emacsclient -e '(progn (load "$(CURDIR)/helpers/derive-version.el") (format-version "$<"))' | sed 's/"//g' > $@
	echo "← generated `date '+%m/%d %H:%M'` from [[file:$<][$<]]" >> $@
	echo "by [[file:helpers/derive-version.el][derive-version.el]]" >> $@
	-@chgrp tmp $@

$(quicklispDir)/%.org: %.org
	cat $< > $@
	-@chgrp tmp $@
