# Installation

<!-- vscode-markdown-toc -->

-   1. [Download with git](#Downloadwithgit)
-   2. [Add as a submodule](#Addasasubmodule)
    -   2.1. [Example for submodule usage](#Exampleforsubmoduleusage)
-   3. [Direct download](#Directdownload)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## 1. <a name='Downloadwithgit'></a>Download with git

```bash
cd fullpath_to_directory_where_to_install

# use git to download the code
git clone https://github.com/cpp-lln-lab/CPP_BIDS.git

# move into the folder you have just created
cd CPP_BIDS

# add the src folder to the matlab path and save the path
matlab -nojvm -nosplash -r "addpath(fullfile(pwd, 'src')); savepath ();"
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

## 2. <a name='Addasasubmodule'></a>Add as a submodule

Add it as a submodule in the repo you are working on.

```bash
cd fullpath_to_directory_where_to_install

# use git to download the code
git submodule add https://github.com/cpp-lln-lab/CPP_BIDS.git

# move into the folder you have just created
cd CPP_BIDS

# add the src folder to the matlab path and save the path
matlab -nojvm -nosplash -r "addpath(fullfile(pwd, 'src'))"
```

To get the latest commit you then need to update the submodule with the
information on its remote repository and then merge those locally.

```bash
git submodule update --remote --merge
```

Remember that updates to submodules need to be committed as well.

### 2.1. <a name='Exampleforsubmoduleusage'></a>Example for submodule usage

So say you want to clone a repo that has some nested submodules, then you would
type this to get the content of all the submodules at once (here with assumption
that you want to clone my experiment repo):

```bash
# clone the repo
git clone https://github.com/user_name/myExperiment.git

# go into the directory
cd myExperiment

# initialize and get the content of the first level of submodules  (e.g. CPP_PTB and CPP_BIDS)
git submodule init
git submodule update

# get the nested submodules JSONio and BIDS-matlab for CPP_BIDS
git submodule foreach --recursive 'git submodule init'
git submodule foreach --recursive 'git submodule update'
```

## 3. <a name='Directdownload'></a>Direct download

Download the code. Unzip. And add to the matlab path.

Pick a specific version:

https://github.com/cpp-lln-lab/CPP_BIDS/releases

Or take the latest commit (NOT RECOMMENDED):

https://github.com/cpp-lln-lab/CPP_BIDS/archive/master.zip
