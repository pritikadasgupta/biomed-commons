#!/bin/python3
# File: python/tests/test_commons.py
# Author: Rose (Pritika) Dasgupta
# Description: Python test skeleton
#
# Style:

import importlib
import types
import pytest

@pytest.fixture
def maybe_pkg():
    try:
        pkg = importlib.import_module("biomed_commons")
    except Exception:
        pytest.skip("biomed_commons package not implemented yet.")
    return pkg

def test_has_expected_names(maybe_pkg):
    names = [
        "clean_colnames",
        "tabulate_oneway",
        "tabulate_by_group",
        "summarize_numeric_overall",
        "summarize_numeric_by_group",
    ]
    for nm in names:
        assert hasattr(maybe_pkg, nm), f"Missing function: {nm}"
