# how to run the tests

- Install [MOxUnit for matlab and octave](https://github.com/MOxUnit/MOxUnit) to run the tests
- Install [MOcov for matlab and octave](https://github.com/MOcov/MOcov) to get the code coverage
- Make sure you are in the `tests` directory.
- Run `moxunit_runtests` or `moxunit_runtests -verbose` to run the tests.

This should tell you which tests pass or fail.
  
The following command would give more info and will give you HTML output in a `coverage_html` folder
showing you which lines of code is or is not checked by your test suite.

``` matlab
success = moxunit_runtests(pwd, ... % the path where the tests are
    '-verbose', ...
    '-with_coverage', ...
    '-cover', fullfile(pwd, '..'), ... % the path of the code whose coverage we want to estimate
    '-cover_xml_file','coverage.xml', ...
    '-cover_html_dir','coverage_html');
```



