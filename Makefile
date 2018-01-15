DOC=DOCUMENTATION.md

all: docs toc

install:
	npm install -g https://github.com/naumazeredo/moxygen/tarball/master

docs:
	tail -n +26 bc.hpp > bc_p.hpp
	g++ -C -E bc_p.hpp > bc_.hpp
	doxygen Doxyfile
	moxygen -a -o $(DOC) -l cpp xml/
	sed -i 's/{[^}]*}//' DOCUMENTATION.md
	rm bc_*.hpp

toc:
	-echo "Building TOC..."
	wget https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
	chmod a+x gh-md-toc
	sed -i 's/^####/###/' $(DOC)
	./gh-md-toc $(DOC) > toc
	sed -i '/Parameters/d' toc
	sed -i '/Returns/d' toc
	sed -i '/Exceptions/d' toc
	sed -i 's/^###/####/' $(DOC)
	echo "" >> toc
	cat $(DOC) >> toc
	mv toc $(DOC)
	rm gh-md-toc
