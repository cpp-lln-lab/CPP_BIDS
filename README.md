<!-- lint disable -->

**Try it**

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cpp-lln-lab/CPP_BIDS/master?filepath=notebooks%2Fbasic_usage.ipynb)

**Documentation**

[![Documentation Status: stable](https://readthedocs.org/projects/cpp-bids/badge/?version=stable)](https://cpp-bids.readthedocs.io/en/stable/?badge=stable)

**Cite it**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4007674.svg)](https://doi.org/10.5281/zenodo.4007674)

**Unit tests and coverage**

[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/CPP_BIDS/actions)
![](https://github.com/cpp-lln-lab/CPP_BIDS/workflows/CI/badge.svg)

[![codecov](https://codecov.io/gh/cpp-lln-lab/CPP_BIDS/branch/master/graph/badge.svg)](https://codecov.io/gh/cpp-lln-lab/CPP_BIDS)

**Contributors**

[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)

---

# CPP_BIDS

<!-- TOC -->

-   [CPP_BIDS](#cpp_bids)
-   [Output format](#output-format)
    -   [Modality agnostic aspect](#modality-agnostic-aspect)
-   [Documentation](#documentation)
-   [Contributing](#contributing)
    -   [Guidestyle](#guidestyle)
    -   [BIDS naming convention](#bids-naming-convention)
    -   [Change log](#change-log)
    -   [Contributors ✨](#contributors-)

<!-- /TOC -->

<!-- lint enable -->

A set of function for matlab and octave to create
[BIDS-compatible](https://bids-specification.readthedocs.io/en/stable/) folder
structure and filenames for the output of behavioral, EEG, fMRI, eyetracking
studies.

## Documentation

-   [Installation](./docs/installation.md)
-   [How to use it: jupyter notebooks](./notebooks)
-   [General documentation](https://cpp-bids.readthedocs.io/en/dev/index.html)

## Contributing

Feel free to open issues to report a bug and ask for improvements.

If you want to contribute, have a look at our
[contributing guidelines](https://github.com/cpp-lln-lab/.github/blob/main/CONTRIBUTING.md)
that are meant to guide you and help you get started. If something is not clear
or you get stuck: it is more likely we did not do good enough a job at
explaining things. So do not hesitate to open an issue, just to ask for
clarification.

### Style guide

-   We use camelCase.

-   We keep the McCabe complexity as reported by the
    [check_my_code function](https://github.com/Remi-Gau/check_my_code)
    below 15.

-   We use the
    [MISS_HIT linter](https://florianschanda.github.io/miss_hit/style_checker.html)
    to automatically fix some linting issues.

### BIDS naming convention

Here are the naming templates used.

-   Behavior

```bash
sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_run-<index>]_events.tsv
sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_run-<index>]_events.json
sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_run-<index>]_beh.tsv
sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_run-<index>]_beh.json
```

-   BOLD

```bash
sub-<label>[_ses-<label>]_task-<label>[_acq-<label>][_ce-<label>][_dir-<label>][_rec-<label>][_run-<index>][_echo-<index>]_<contrast_label>.nii[.gz]
```

-   iEEG

```bash
sub-<label>[_ses-<label>]_task-<task_label>[_run-<index>]_ieeg.json
```

-   EEG

```bash
sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.<manufacturer_specific_extension>
sub-<label>[_ses-<label>]_task-<label>[_run-<index>]_eeg.json
```

<!-- European data format (Each recording consisting of a .edf file)

BrainVision Core Data Format (Each recording consisting of a .vhdr, .vmrk, .eeg file triplet)

The format used by the MATLAB toolbox EEGLAB (Each recording consisting of a .set file with an optional .fdt file)

Biosemi data format (Each recording consisting of a .bdf file) -->

-   MEG

???

-   Eyetracker

current format `<matches>_recording-eyetracking_physio.tsv.gz`

future BEP format in a dedicated eyetracker folder

```bash
sub-<participant_label>[_ses-<label>][_acq-<label>]_task-<task_label>_eyetrack.<manufacturer_specific_extension>
```

-   Stim and physio

```bash
<matches>[_recording-<label>]_physio.tsv.gz
<matches>[_recording-<label>]_physio.json
<matches>[_recording-<label>]_stim.tsv.gz
<matches>[_recording-<label>]_stim.json
```

### Change log

 <!-- 93b4c584bf22883a3c4f8b9031b70e381deef272 -->

### Contributors ✨

Thanks goes to these wonderful people
([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars1.githubusercontent.com/u/10451654?v=4?s=100" width="100px;" alt=""/><br /><sub><b>CerenB</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Code">💻</a> <a href="#design-CerenB" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=CerenB" title="Documentation">📖</a> <a href="#userTesting-CerenB" title="User Testing">📓</a> <a href="#ideas-CerenB" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/issues?q=author%3ACerenB" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars3.githubusercontent.com/u/38101692?v=4?s=100" width="100px;" alt=""/><br /><sub><b>marcobarilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=marcobarilari" title="Code">💻</a> <a href="#design-marcobarilari" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=marcobarilari" title="Documentation">📖</a> <a href="#userTesting-marcobarilari" title="User Testing">📓</a> <a href="#ideas-marcobarilari" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/issues?q=author%3Amarcobarilari" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://remi-gau.github.io/"><img src="https://avatars3.githubusercontent.com/u/6961185?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Code">💻</a> <a href="#design-Remi-Gau" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Documentation">📖</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/issues?q=author%3ARemi-Gau" title="Bug reports">🐛</a> <a href="#userTesting-Remi-Gau" title="User Testing">📓</a> <a href="#ideas-Remi-Gau" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-Remi-Gau" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#maintenance-Remi-Gau" title="Maintenance">🚧</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=Remi-Gau" title="Tests">⚠️</a> <a href="#question-Remi-Gau" title="Answering Questions">💬</a></td>
    <td align="center"><a href="https://github.com/TomasLenc"><img src="https://avatars1.githubusercontent.com/u/10827440?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Tomas Lenc</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=TomasLenc" title="Code">💻</a> <a href="#ideas-TomasLenc" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=TomasLenc" title="Tests">⚠️</a></td>
    <td align="center"><a href="https://github.com/iqrashahzad14"><img src="https://avatars.githubusercontent.com/u/75671348?v=4?s=100" width="100px;" alt=""/><br /><sub><b>iqrashahzad14</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_BIDS/issues?q=author%3Aiqrashahzad14" title="Bug reports">🐛</a> <a href="https://github.com/cpp-lln-lab/CPP_BIDS/commits?author=iqrashahzad14" title="Tests">⚠️</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind welcome!
