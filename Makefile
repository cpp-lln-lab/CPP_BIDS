# TODO make more general to use the local matlab version
MATLAB = /usr/local/MATLAB/R2017a/bin/matlab
ARG    = -nodisplay -nosplash -nodesktop

<<<<<<< HEAD
=======
.PHONY: clean manual clean_demos fix_submodule
clean: clean_demos
	rm -rf version.txt

fix_submodule:
	git submodule update --init --recursive && git submodule update --recursive

>>>>>>> 3a67904c66439e90c8fc528ac8729254b91d56d6
lint:
	mh_style --fix && mh_metric --ci && mh_lint

test:
	$(MATLAB) $(ARG) -r "runTests; exit()"

version.txt: CITATION.cff
	grep -w "^version" CITATION.cff | sed "s/version: /v/g" > version.txt

validate_cff: CITATION.cff
	cffconvert --validate

manual:
	cd docs && sh create_manual.sh
