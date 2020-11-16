Setting up your experiment
**************************

Configuration
=============

.. todo:
   describe how to set things up


.. automodule:: src
.. autofunction:: checkCFG

.. automodule:: src.utils
.. autofunction:: transferInfoToBids

.. todo:
    0: almost nothing gets printed on screen
    1: allows saveEvents to print stuff when saving to file or createFilename to tell you where things will be saved
    2: let printCredits do its job and lets saveEvents print extra info when it sends some warning.

Group, subject, session and run
===============================

You can use the ``userInputs()`` function to easily set the group name as well as
the subject, session and run number. You can ask the function to not bother you with 
group and session 


.. todo:

    Get subject, run and session number and make sure they are positive integer
    values.

    By default this will return `cfg.subject.session = 1` even if you asked it to
    omit enquiring about sessions. This means that the folder tree will always
    include a session folder.

    ```matlab
    [cfg] = userInputs(cfg)
    ```

    If you use it with `cfg.subject.askGrpSess = [0 0]`, it won't ask you about
    group or session.

    If you use it with `cfg.subject.askGrpSess = [1]`, it will only ask you about
    group

    If you use it with `cfg.subject.askGrpSess = [0 1]`, it will only ask you about
    session

    If you use it with `cfg.subject.askGrpSess = [1 1]`, it will ask you about both.
    This is the default behavior.