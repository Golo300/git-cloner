#!/usr/bin/env python

from setuptools import setup, find_packages

setup(name='git-cloner',
      version='0.1',
      # Modules to import from other scripts:
      packages=find_packages(),
      # Executables
      scripts=["git-cloner.py"],
     )
