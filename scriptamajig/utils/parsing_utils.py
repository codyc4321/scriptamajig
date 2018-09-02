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
        command_raw = command_raw.strip()
        command = command_raw[1:-1]
        return {'type': 'alias', 'name': name, 'data': command}
    else:
        return None


def is_bash_function(text):
    rgx = r"""^(\w+)\s*[(][)]\s*[{]"""
    return parse_group(rgx, text)


def is_bash_function_end(text):
    rgx = r"""^\s*[}]"""
    return bool(re.search(rgx, text))


def is_single_line_bash_function(text):
    rgx = r"""^(\w+)\s*[(][)]\s*[{](.*?)[}]"""
    match = re.search(rgx, text)
    try:
        return {'type': 'bash_func', 'name': match.groups()[0], 'data': match.groups()[1].rstrip(';').strip()}
    except:
        return None


def is_script(text):
    rgx = r"""[.](rb|py|sh)('|")\s*$"""
    return parse_group(rgx, text)


def is_filepath(text):
    rgx = r"""^(?P<name>\w+)[=]('|")(?P<path>.*?)('|")$"""
    match = re.search(rgx, text)
    if match:
        return {'type': 'path', 'name': match.group('name'), 'data': match.group('path')}
    return None


def grab_single_line_match(text):
    simple_single_line_parsers = [
        is_alias,
        is_single_line_bash_function,
        is_filepath,
    ]

    for parser in simple_single_line_parsers:
        match = parser(text)
        if match:
            return match
    return None


def parse_bash_file(lines):
    # they have no category, or no home
    # orphaned_commands = []
    filepaths = {}
    main_data = {'orphans': [] }

    current_category = None

    current_bash_func_name = None
    current_bash_func_commands = ""

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

        easy_match = grab_single_line_match(line)
        if easy_match:
            if easy_match['type'] == 'path':
                filepaths[easy_match['name']] = easy_match['data']

            try:
                main_data[current_category].append(easy_match)
            except:
                main_data['orphans'].append(easy_match)
        else:
            print("No easy match")
            bash_func_name = is_bash_function(line)
            if bash_func_name:
                current_bash_func_name = bash_func_name
            else:
                # do in else, because you dont want to add a line like
                # 'mycmpushall() {' to the commands list
                ends_bash_func = is_bash_function_end(line)
                if ends_bash_func:
                    if current_bash_func_name:
                        this_bash_func = {
                            'type': 'bash_func',
                            'name': current_bash_func_name,
                            'data': current_bash_func_commands
                        }

                        try:
                            main_data[current_category].append(this_bash_func)
                        except:
                            main_data['orphans'].append(this_bash_func)

                    current_bash_func_name = None
                    current_bash_func_commands = ""
                    continue

                if current_bash_func_name:
                    current_bash_func_commands += line.replace('\n', '') + "; "


    return {'main_data': main_data, 'filepaths': filepaths}


def sort_parsed_data(data):
    sorted_data = {}
    for key in data.keys():
        sorted_data[key] = sorted(data[key], key=lambda k: k['name'])
    return sorted_data


#-------------------------------------------------------------------------
# expand filepaths

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


def expand_all_filepaths(filepaths):
    HOME = os.path.expanduser('~')

    home_expanded_paths = {}
    for key, value in filepaths.items():
        home_expanded_paths[key] = value.replace('$HOME', HOME)

    # since some get an incomplete replacement (replacing '$CODE_META_SCRIPTS_PATH/ast' to '$SCRIPTS/code_meta/ast'),
    # we do a second pass after this
    intermediate_expanded_paths = {}
    for key, value in home_expanded_paths.items():
        # if key == 'AST_SCRIPTS_PATH':
        #     import ipdb; ipdb.set_trace()
        intermediate_expanded_paths[key] = construct_full_filepath(value, home_expanded_paths)

    final_expanded_paths = {}
    for key, value in intermediate_expanded_paths.items():
        # if key == 'AST_SCRIPTS_PATH':
        #     import ipdb; ipdb.set_trace()
        final_expanded_paths[key] = construct_full_filepath(value, home_expanded_paths)

    return final_expanded_paths



data = parse_bash_file(lines)

for key, value in sort_parsed_data(data['main_data']).items():
    print(key)
    print(value)
    print('\n')
    # time.sleep(3)

print(expand_all_filepaths(data['filepaths']))
