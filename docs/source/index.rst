.. cpp_bids documentation master file

Welcome to CPP BIDS documentation!
**********************************

.. toctree::
   :maxdepth: 2
   :caption: Content

   set_up
   function_description
   utilities
   gui
   contributing

A set of function for matlab and octave to create
`BIDS-compatible <https://bids-specification.readthedocs.io/en/stable/>`_
structure and filenames for the output of behavioral, EEG, fMRI, eyetracking
experiments.

Output format
=============

Modality agnostic aspect
------------------------

The files created by this toolbox will always follow the following pattern::

  dataDir/sub-<[Group]SubNb>/ses-sesNb/sub-<[Group]SubNb>_ses-<sesNb>_task-<taskName>*_modality_date-*.fileExtension

Subjects, session and run number labels will be numbers with zero padding up (default is set to
3, meaning that subject 1 will become ``sub-001``).

The ``Group`` name is optional.

A session folder will ALWAYS be created even if not requested (default will be ``ses-001``).

Task labels will be printed in ``camelCase`` in the filenames.

Time stamps are added directly in the filename by adding a suffix
``_date-*`` (default format is ``YYYYMMDDHHMM``) which makes the file name non-BIDS compliant. 
This was added to prevent overwriting files in case a certain run needs to be done 
a second time because of a crash. 
Some of us are paranoid about keeping even cancelled runs during my experiments. 
This suffix should be removed to make the data set BIDS compliant. 
See ``convertSourceToRaw()`` for more details.

For example::

  /user/bob/dataset002/sub-090/ses-003/sub-090_ses-003_task-auditoryTask_run-023_events_date-202007291536.tsv


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
