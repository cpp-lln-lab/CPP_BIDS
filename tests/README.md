# how to run the tests

-   Install [MOxUnit for matlab and octave](https://github.com/MOxUnit/MOxUnit)
    to run the tests

-   Install [MOcov for matlab and octave](https://github.com/MOcov/MOcov) to get
    the code coverage

-   Make sure the following folders and sub-folders are in the Octave / MATLAB
    path:

    -   `src`
    -   `lib`
    -   `tests/utils`

-   Run `moxunit_runtests tests` or `moxunit_runtests tests -verbose` to run the
    tests.

This should tell you which tests pass or fail.

## Adding more tests

You can use the function template to write more tests.

It is in the [`src/templates` folder](../src/templates)

## Manual tests

This is the folder where we keep tests that can not be run in continuous
integration even as simple "smoke tests".

<!-- ## code coverage

A lot of what follows does not really work locally because of needing to add the right
folders to the path to get an accurate coverage.

The following command would give more info and will give you HTML output in a
`coverage_html` folder showing you which lines of code is or is not checked by
your test suite.

```matlab
success = moxunit_runtests('tests', ... % the path where the tests are
    '-verbose', ...
    '-with_coverage', ...
    '-cover', fullfile(pwd, 'src'), ... % the path of the code whose coverage we want to estimate
    '-cover_xml_file','coverage.xml', ...
    '-cover_html_dir','coverage_html');
```

This will return a clear underestimation of the code coverage as the the code in
dependencies in the `lib` folder are also included in this report.

If you want to get a slightly more accurate estimate you should run the
following.

I have not been able to find a way to exclude certain files without breaking
some tests.

```matlab
coverage = mocov( ...
    '-expression', "moxunit_runtests('test')", ...
    '-verbose', ...
    '-cover', fullfile(pwd, 'src'), ...
    '-cover_exclude', '*jsonread.m', ...
    '-cover_exclude', '*json*code.m', ...
    '-cover_exclude', '*Contents.m', ...
    '-cover_exclude', '*report.m', ...
    '-cover_exclude', '*layout.m', ...
    '-cover_exclude', '*query.m', ...
    '-cover_exclude', '*private*', ...
    '-cover_exclude', '*util*', ...
    '-cover_exclude', '*Tests*', ...
    '-cover_exclude', '*tests*', ...
    '-cover_exclude', '*test_*', ...
    '-cover_xml_file','coverage.xml', ...
    '-cover_html_dir','coverage_html')
``` -->
