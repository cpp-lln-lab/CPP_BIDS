# functions description

<!-- lint disable -->

<!-- TOC -->

-   [functions description](#functions-description)
    -   [createFilename](#createfilename)
    -   [saveEventsFile](#saveeventsfile)
    -   [createBoldJson](#createboldjson)

<!-- /TOC -->

<!-- lint enable -->

## createFilename

Create the BIDS compliant directories and filenames (but not the files) for the
behavioral output for this subject / session / run.

The folder tree will always include a session folder.

It will also create the right filename for the eye-tracking data file if you ask
it.

For the moment the date of acquisition is appended to the filename

-   can work for behavioral experiment if `cfg.testingDevice` is set to `pc`,
-   can work for fMRI experiment if `cfg.testingDevice` is set to `mri`,
-   can work for simple eyetracking data if `cfg.eyeTracker.do` is set to 1.

## saveEventsFile

Function to save output files for events that will be BIDS compliant.

If the user DOES NOT provide `onset`, `trial_type`, this events will be skipped.
`duration` will be set to `n/a` if no value is provided.

## createBoldJson

```bash
createBoldJson(cfg)
```

This function creates a very light-weight version of the side-car JSON file for
a BOLD functional run.

This will only contain the minimum BIDS requirement and will likely be less
complete than the info you could from DICOM conversion.

If you put the following line at the end of your experiment script, it will dump
the content of the `extraInfo` structure in the json file.

```bash
createBoldJson(cfg, extraInfo)
```

This allows to add all the parameters that you used to run your experiment in a
human readable format: so that when you write your methods sections 2 years
later ("the reviewer asked me for the size of my fixation cross... FML"), the
info you used WHEN you ran the experiment is saved in an easily accessible text
format. For the love of the flying spaghetti monster do not save all your
parameters in a `.mat` file: think of the case when you won't have matlab or
octave installed on a computer (plus not everyone uses those).

Also to reading your experiment parameters, you won't have to read it from the
`setParameters.m` file and wonder if those might have been modified when running
the experiment and you did not commit and tagged that change with git.
