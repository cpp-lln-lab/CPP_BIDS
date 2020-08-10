**Unit tests and coverage**

[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/CPP_BIDS/actions)
![](https://github.com/cpp-lln-lab/CPP_BIDS/workflows/CI/badge.svg) 

[![codecov](https://codecov.io/gh/cpp-lln-lab/CPP_BIDS/branch/master/graph/badge.svg)](https://codecov.io/gh/cpp-lln-lab/CPP_BIDS)

**BIDS validator and linter**

[![Build Status](https://travis-ci.com/cpp-lln-lab/CPP_BIDS.svg?branch=master)](https://travis-ci.com/cpp-lln-lab/CPP_BIDS)

**Contributors**

[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-) 

---
 
# CPP_BIDS

<!-- vscode-markdown-toc -->
* 1. [Output format](#Outputformat)
	* 1.1. [Modality agnostic aspect](#Modalityagnosticaspect)
* 2. [Documentation](#Documentation)
* 3. [Contributing](#Contributing)
	* 3.1. [Guidestyle](#Guidestyle)
	* 3.2. [BIDS naming convention](#BIDSnamingconvention)
	* 3.3. [Contributors ✨](#Contributors)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

A set of function for matlab and octave to create [BIDS-compatible](https://bids-specification.readthedocs.io/en/stable/) folder structure and filenames for the output of behavioral, EEG, fMRI, eyetracking studies.

##  1. <a name='Outputformat'></a>Output format

###  1.1. <a name='Modalityagnosticaspect'></a>Modality agnostic aspect

Subjects, session and run number labels will be numbers with zero padding up to 3 values (e.g subject 1 will become `sub-001`).

A session folder will ALWAYS be created even if not requested (default will be `ses-001`).

Task labels will be printed in camelCase in the filenames.

Time stamps are added directly in the filename by adding a suffix `_date-YYYYMMDDHHMM` which makes the file name non-BIDS compliant. This was added to prevent overwriting files in case a certain run needs to be done a second time because of a crash (Some of us are paranoid about keeping even cancelled runs during my experiments). This suffix should be removed to make the data set BIDS compliant. See `convertSourceToRaw.m` for more details.

For example:

```
sub-090/ses-003/sub-090_ses-003_task-auditoryTask_run-023_events_date-202007291536.tsv
```

##  2. <a name='Documentation'></a>Documentation

- [Installation](./docs/installation.md)
- [How to use it: jupyter notebooks](./notebooks)
- [Functions description](./docs/functions_description.md)

##  3. <a name='Contributing'></a>Contributing

Feel free to open issues to report a bug and ask for improvements.

###  3.1. <a name='Guidestyle'></a>Guidestyle

-   We use camelCase.
-   We keep the McCabe complexity as reported by the [check_my_code function](https://github.com/Remi-Gau/check_my_code) below 15.
-   We use the [MISS_HIT linter](https://florianschanda.github.io/miss_hit/style_checker.html) to automatically fix some linting issues.

###  3.2. <a name='BIDSnamingconvention'></a>BIDS naming convention

Here are the naming templates used.

-   BOLD

`sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_ce-<label>][_dir-<label>][_rec-<label>][_run-<index>][_echo-<index>]_<contrast_label>.nii[.gz]`

-   iEEG

`sub-<label>[_ses-<label>]_task-<task_label>[_run-<index>]_ieeg.json`

-   EEG

`sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.<manufacturer_specific_extension>`

-   MEG

???

-   Eyetracker

`sub-<participant_label>[_ses-<label>][_acq-<label>]_task-<task_label>_eyetrack.<manufacturer_specific_extension>`

###  3.3. <a name='Contributors'></a>Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars1.githubusercontent.com/u/10451654?v=4" width="100px;" alt=""/><br /><sub><b>CerenB</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Code">💻</a> <a href="#design-CerenB" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars3.githubusercontent.com/u/38101692?v=4" width="100px;" alt=""/><br /><sub><b>marcobarilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=marcobarilari" title="Code">💻</a> <a href="#design-marcobarilari" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=marcobarilari" title="Documentation">📖</a></td>
    <td align="center"><a href="https://remi-gau.github.io/"><img src="https://avatars3.githubusercontent.com/u/6961185?v=4" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Code">💻</a> <a href="#design-Remi-Gau" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
