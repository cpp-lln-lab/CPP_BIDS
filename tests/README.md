# how to run the tests

- Install [MOxUnit for matlab and octave](https://github.com/MOxUnit/MOxUnit) to run the tests
- Install [MOcov for matlab and octave](https://github.com/MOcov/MOcov) to get the code coverage
- Make sure you are in the `tests` directory.
- Run `moxunit_runtests` or `moxunit_runtests -verbose` to run the tests.

This should tell you which tests pass or fail.
  
## code coverage

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
This will return a clear underestimation of the code coverage as the the code in dependencies in the `lib` folder
are also included in this report.

If you want to get a slightly more accurate estimate you should run the following.

I have not been able to find a way to exclude certain files without breaking some tests.

```matlab
coverage = mocov( ...
    '-expression', 'moxunit_runtests()', ...
    '-verbose', ...
    '-cover', fullfile(pwd, '..'), ...
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
```


## Adding more tests

You can use the following function template to write more tests.


```matlab
function test_suite = test_functionToTest()
    % This top function is necessary for mox unit to run tests. 
    % DO NOT CHANGE IT except to adapt the name of the function.
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_functionToTestBasic()

    %% set up


    %% data to test against
    

    %% test
    % assertTrue( );
    % assertFalse( );
    % assertEqual( );

end

function test_functionToTestUseCase1()

    %% set up


    %% data to test against
    

    %% test
    % assertTrue( );
    % assertFalse( );
    % assertEqual( );

end
```

