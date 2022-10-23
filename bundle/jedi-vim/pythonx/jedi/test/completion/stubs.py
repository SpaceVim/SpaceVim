from stub_folder import with_stub, stub_only, with_stub_folder, stub_only_folder

# -------------------------
# Just files
# -------------------------

#? int()
stub_only.in_stub_only
#? str()
with_stub.in_with_stub_both
#? int()
with_stub.in_with_stub_python
#? float()
with_stub.in_with_stub_stub

#! ['in_stub_only: int']
stub_only.in_stub_only
#! ['in_with_stub_both = 5']
with_stub.in_with_stub_both
#! ['in_with_stub_python = 8']
with_stub.in_with_stub_python
#! ['in_with_stub_stub: float']
with_stub.in_with_stub_stub

#? ['in_stub_only']
stub_only.in_
#? ['in_stub_only']
from stub_folder.stub_only import in_
#? ['in_with_stub_both', 'in_with_stub_python', 'in_with_stub_stub']
with_stub.in_
#? ['in_with_stub_both', 'in_with_stub_python', 'in_with_stub_stub']
from stub_folder.with_stub import in_

#? ['with_stub', 'stub_only', 'with_stub_folder', 'stub_only_folder']
from stub_folder.


# -------------------------
# Folders
# -------------------------

#? int()
stub_only_folder.in_stub_only_folder
#? str()
with_stub_folder.in_with_stub_both_folder
#? int()
with_stub_folder.in_with_stub_python_folder
#? float()
with_stub_folder.in_with_stub_stub_folder

#? ['in_stub_only_folder']
stub_only_folder.in_
#? ['in_with_stub_both_folder', 'in_with_stub_python_folder', 'in_with_stub_stub_folder']
with_stub_folder.in_

# -------------------------
# Folders nested with stubs
# -------------------------

from stub_folder.with_stub_folder import nested_stub_only, nested_with_stub, \
    python_only

#? int()
nested_stub_only.in_stub_only
#? float()
nested_with_stub.in_both
#? str()
nested_with_stub.in_python
#? int()
nested_with_stub.in_stub
#? str()
python_only.in_python

#? ['in_stub_only_folder']
stub_only_folder.in_
#? ['in_with_stub_both_folder', 'in_with_stub_python_folder', 'in_with_stub_stub_folder']
with_stub_folder.in_
#? ['in_python']
python_only.in_

# -------------------------
# Folders nested with stubs
# -------------------------

from stub_folder.stub_only_folder import nested_stub_only, nested_with_stub, \
    python_only

#? int()
nested_stub_only.in_stub_only
#? float()
nested_with_stub.in_both
#? str()
nested_with_stub.in_python
#? int()
nested_with_stub.in_stub
#? str()
python_only.in_python

#? ['in_stub_only']
nested_stub_only.in_
#? ['in_both', 'in_python', 'in_stub']
nested_with_stub.in_
#? ['in_python']
python_only.in_
