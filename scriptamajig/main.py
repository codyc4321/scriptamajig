#!/usr/bin/env python

import os
import re
import time

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
    rgx = r"^\s*[#]\s*(.*?)[*]\s*$"
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
        command_rgx = r"[=](.*?)\s*$"
        command_raw = parse_group(command_rgx, text)
        print(text)
        command_raw = command_raw.strip()
        command = command_raw[1:-1]
        return {'name': name, 'command': command}
    else:
        return None


def is_bash_function(text):
    rgx = r"""^(\w+)\s*[(][)]\s*[{]"""
    return parse_group(rgx, text)


def is_single_line_bash_function(text):
    rgx = r"""^(\w+)\s*[(][)]\s*[{](.*?)[}]"""
    match = re.search(rgx, text)
    try:
        return {'name': match.groups()[0], 'command': match.groups()[1].rstrip(';').strip()}
    except:
        return None


def is_script(text):
    rgx = r"""[.](rb|py|sh)('|")\s*$"""
    return parse_group(rgx, text)


def is_filepath(text):
    rgx = r"""^(?P<name>\w+)[=]('|")(?P<path>.*?)('|")$"""
    match = re.search(rgx, text)
    if match:
        return {'name': match.group('name'), 'path': match.group('path')}
    return None


def gather_names_to_substitute(text):
    rgx = r"[$]\w+"
    matches = re.findall(rgx, text)
    return map(lambda x: x.replace('$', ''), matches)


def construct_full_filepath(text, filepaths_map):
    # substitutes all the $NAMEs and whatnot
    names = gather_names_to_substitute(text)
    for name in names:
        text = text.replace("$" + name, filepaths_map[name])
    return text

# def is_bash_var(text):
#     # rgx = r"""^(?P<name>\w+)[=]('|")(?P<path>.*?)('|")$"""
#     pass

def grab_single_line_match(text):
    simple_single_line_parsers = [
        is_alias,
        is_single_line_bash_function,
        is_script,
        is_filepath,
    ]

    for parser in simple_single_line_parsers:
        match = parser(text)
        if match:
            return match
    return None


def run_parsers(lines):
    # they have no category, or no home
    orphaned_commands = []
    filepaths = []
    main_data = {}

    current_category = None

    # these parsers match the line itself, then we can move on to next line
    simple_single_line_parsers = [
        is_alias,
        is_single_line_bash_function,
        is_script,
        is_filepath,
    ]

    for line in lines:
        category = is_category_name(line)
        if category:
            current_category = category
            main_data[category] = []
            continue
        else:
            is_category_ending = is_category_name_ending_here(line)
            if is_category_ending:
                current_category = None
                continue






    return {'main_data': main_data}

data = run_parsers(lines)
print(data)
