<!-- markdown-link-check-disable -->

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cpp-lln-lab/CPP_BIDS/master?filepath=notebooks%2Fbasic_usage.ipynb)
[![Documentation Status: stable](https://readthedocs.org/projects/cpp-bids/badge/?version=stable)](https://cpp-bids.readthedocs.io/en/stable/?badge=stable)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4007674.svg)](https://doi.org/10.5281/zenodo.4007674)
[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/CPP_BIDS/actions)
![](https://github.com/cpp-lln-lab/CPP_BIDS/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/cpp-lln-lab/CPP_BIDS/branch/master/graph/badge.svg)](https://codecov.io/gh/cpp-lln-lab/CPP_BIDS)
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)

<!-- markdown-link-check-enable -->

# CPP_BIDS

A set of function for matlab and octave to create
[BIDS-compatible](https://bids-specification.readthedocs.io/en/stable/) folder
structure and filenames for the output of behavioral, EEG, fMRI, eyetracking
studies.

## Installation

### Use the CPP templates for PsychToolBox experiments

The easiest way to use this repository is to create a new repository by using
the
[template PTB experiment repository](https://github.com/cpp-lln-lab/template_PTB_experiment):
this creates a new repository on your github account with all the basic folders,
files and submodules (including CPP_BIDS) already set up. You only have to then
clone the repository and you are good to go.

### Download with git

```bash
cd fullpath_to_directory_where_to_install

# use git to download the code and the submodules
git clone --recurse-submodules https://github.com/cpp-lln-lab/CPP_BIDS.git
```

Then get the latest commit:

```bash
# from the directory where you downloaded the code
git pull origin master
```

To work with a specific version, create a branch at a specific version tag
number

```bash
# creating and checking out a branch that will be called version1 at the version tag v0.0.1
git checkout -b version1 v2.2.1
```

### Add as a submodule

Add it as a submodule in the repo you are working on.

```bash
cd fullpath_to_directory_where_to_install

# use git to download the code
git submodule add https://github.com/cpp-lln-lab/CPP_BIDS.git
```

To get the latest commit you then need to update the submodule with the
information on its remote repository and then merge those locally.

```bash
git submodule update --remote --merge
```

Remember that updates to submodules need to be committed as well.

#### Example

So say you want to clone a repo that has some nested submodules, then you would
type this to get the content of all the submodules at once (here with assumption
that you want to clone my experiment repo):

```bash
# clone the repo
git clone https://github.com/user_name/myExperiment.git

# go into the directory
cd myExperiment

# initialize and get the content of the first level of submodules
git submodule init
git submodule update

# get the nested submodules JSONio and BIDS-matlab for CPP_BIDS
git submodule foreach --recursive 'git submodule init'
git submodule foreach --recursive 'git submodule update'
```

## Demos

[How to use it: jupyter notebooks](./notebooks)

## Documentation

[General documentation](https://cpp-bids.readthedocs.io/en/dev/index.html)

## Contributing

Feel free to open issues to report a bug and ask for improvements.

If you want to contribute, have a look at our
[contributing guidelines](https://github.com/cpp-lln-lab/.github/blob/main/CONTRIBUTING.md)
that are meant to guide you and help you get started. If something is not clear
or you get stuck: it is more likely we did not do good enough a job at
explaining things. So do not hesitate to open an issue, just to ask for
clarification.

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
