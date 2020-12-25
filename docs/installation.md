# Installation

<!-- lint disable -->

<!-- TOC -->

-   [Installation](#installation)
    -   [Download with git](#download-with-git)
    -   [Add as a submodule](#add-as-a-submodule)
        -   [Example for submodule usage](#example-for-submodule-usage)
    -   [Direct download](#direct-download)

<!-- /TOC -->

<!-- lint enable -->

## Use the CPP templates for PsychToolBox experiments

The easiest way to use this repository is to create a new repository by using
the
[template PTB experiment repository](https://github.com/cpp-lln-lab/template_PTB_experiment):
this creates a new repository on your github account with all the basic folders,
files and submodules (including CPP_BIDS) already set up. You only have to then
clone the repository and you are good to go.

## Download with git

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
git checkout -b version1 v0.0.1
```

## Add as a submodule

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

### Example for submodule usage

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

## Direct download

NOT RECOMMENDED.

Download the code. Unzip. And add to the matlab path.

Pick a specific version from
[HERE](https://github.com/cpp-lln-lab/CPP_BIDS/releases)

Or take the
[latest commit](https://github.com/cpp-lln-lab/CPP_BIDS/archive/master.zip) (NOT
RECOMMENDED).
