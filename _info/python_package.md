# new style

repo layout to be able to `pip install git+http://repo/project.git`

```sh
git_repo/
├── my_package/
│   ├── core/
│   │   ├── my_package_calls.py
│   │   ├── my_package_parsers.py
│   │   ├── session.py
│   │   ├── utilities.py
│   │   └── __init__.py
│   └── __init__.py
├── README.md
└── pyproject.toml
```

```toml
[build-system]
requires = ["setuptools>=68", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "my_packagename"
version = "0.1.0"
description = "Handles API calls"
readme = "README.md"
authors = [
  { name = "lima", email = "my@email" },
]
requires-python = ">=3.6"
dependencies = [
  "requests>=2.21",
  "pprintpp"
]

[project.urls]
Homepage = "https://bitbucket.xyz.com/scm/xzy/xcnm.git"

[tool.setuptools.packages.find]
include = ["my_package*"]
```

# old style

#files needed
root: repo_dir/my_package/ **init**.py README.md setup.py
git_repo
├── my_package
│   ├── core
│   │   ├── my_package_calls.py
│   │   ├── my_package_parsers.py
│   │   ├── **init**.py
│   │   ├── session.py
│   │   └── utilities.py
│   └── **init**.py
├── **init**.py
├── README.md
└── setup.py

`========== setup.py file ==========`

```python
import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="my_packagename",
    version="0.1.0",
    author="lima",
    author_email="my@email",
    description="Handles API calls",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://bitbucket.xyz.com/scm/xzy/xcnm.git",
    packages=setuptools.find_packages(),
    install_requires=['requests>=2.21', 'pprint'],
    python_requires='~=3.6',
    classifiers=[
        "Programming Language :: Python :: 3.6",
        "Operating System :: OS Independent",
    ],
)
```

`========== __init__.py file ==========`

```python
name = "my_package"
```

`========== final step ==========`

python setup.py sdist bdist_wheel

`========== other notes ==========`

impors done within project from modules in the same directory must have a '.'
appended.

examples:

1. if sessions.py is in the same directory
   from .sessions import Session

2. if utilities.py is in same directory
   from .utilities import retry_on_server_error
