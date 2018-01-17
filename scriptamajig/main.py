#!/usr/bin/env python

import os
import re


def read_lines(the_file):
    with open(the_file, 'r') as f:
        return f.readlines()


dir_path = os.path.dirname(os.path.realpath(__file__))

bashprofile_path = os.path.join(dir_path, "bashprofile.sh")

lines = read_lines(bashprofile_path)


MAPPER = {}


def parse_group(rgx, text):
    match = re.search(rgx, text)
    # match.group() will throw an error if empty
    try:
        return match.groups()[0]
    except:
        return None


def is_category_name(text):
    """
    A category name looks like:
        # GIT*
        #GIT*
    """
    rgx = r"^\s*[#]\s*(.*?)[*]"
    return parse_group(rgx, text)


def is_category_name_ending_here(text):
    rgx = r"\s*[#]\s*END\s*"
    return bool(re.search(rgx, text))


def is_alias(text):
    rgx = r"""^alias """
    match = re.search(rgx, text)
    if match:
        name_rgx = r"^alias (.*?)[=]"
        name = parse_group(name_rgx, text)
        command_rgx = r"[=](.*?)\s+$"
        command_raw = parse_group(command_rgx, text)
        command_raw = command_raw.strip()
        command = command_raw[1:-1]
        return {'name': name, 'command': command}
    else:
        return None


def is_bash_function(text):
    print('huh')
    rgx = r"""^(\w+)\s*[(][)]\s*[{]"""
    # match = re.search(rgx, text)
    return parse_group(rgx, text)


def is_python_function():
    pass


def is_filepath():
    pass



def run_parsers():
    parsers = [
        is_category_name,
        is_alias,
        is_bash_function,
        is_python_function,
        is_filepath,
        is_category_name_ending_here
    ]
