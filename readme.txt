Title : Specman-Python
Version : 1.0
Requires : Specman 19.06 and up
Modified : October 2019
Description :

[ More e code examples in https://github.com/efratcdn/spmn-e-utils ]

The example shows how to use a python module that draws a coverage plot during a run from Specman.Note:
1. The exmaple runs from Specman 19.06 with Python 2 and from 19.09 with Python 3.
2. It is recommended first to make sure all Python libraries are installed by uncommenting the last lines in the Python module and run it without Specman.   

To run the exmaple:
1. Update config.sh file and source it
2. To run  the example in loaded mode:
specman -64 -c "load cov_python_i_seq.e;test;"

