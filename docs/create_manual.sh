#!/bin/bash

sphinx-build -M latexpdf source build

cp build/latex/cppbids.pdf cpp_bids-manual.pdf
