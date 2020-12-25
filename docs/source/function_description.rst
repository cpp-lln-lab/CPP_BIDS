Function description
********************
  
List of functions in the ``src`` folder.  

----

.. automodule:: src 

.. autofunction:: convertSourceToRaw
.. autofunction:: createDataDictionary
.. autofunction:: createDatasetDescription
.. autofunction:: createFilename
.. autofunction:: createJson

``createJson`` can be used to save in a
human readable format the extra parameters that you used to run your experiment. 
This will most likely make the json file non-bids compliant but it can prove useful,
to keep this information in your source dataset
for when you write your methods sections 2 years later after running the experiment.
This ensures that those are the exact parameters you used and you won't have 
to read them from the ``setParameters.m`` file and wonder 
if those might have been modified when running the experiment 
and you did not commit and tagged that change with git.

And for the love of the flying spaghetti monster do not save all your
parameters in a `.mat` file: think of the case when you won't have Matlab or
Octave installed on a computer (plus not everyone uses those).

.. autofunction:: readAndFilterLogfile
.. autofunction:: saveEventsFile
.. autofunction:: userInputs


