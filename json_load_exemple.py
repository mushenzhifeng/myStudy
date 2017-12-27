#!/usr/bin/env python
#-*- coding: utf-8 -*-

import json

# this file demonstrate how to read json file
def load(filename):
    with open(filename) as file:
        data = json.load(file)
        return data

my_data = load("my_json")
print my_data

