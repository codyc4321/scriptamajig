import unittest

from scriptamajig.main import (
    parse_group,
    is_category_name,
    is_category_name_ending_here,
    is_alias,
    is_bash_function,
    is_bash_function_end,
    is_single_line_bash_function,
    is_script,
    is_filepath,
    gather_names_to_substitute,
    construct_full_filepath,
    grab_single_line_match,
)


class TestParsingFunctions(unittest.TestCase):

    def test_parse_group_finds_group(self):
        result = parse_group(r"^\s*[#]\s*(.*?)[*]", "# GIT*")
        self.assertEqual(result, "GIT")

    def test_parse_group_returns_None_when_fail(self):
        result = parse_group(r"^\s*[#]\s*(.*?)[*]", "ELEPHANT")
        self.assertIsNone(result)

    def test_is_category_name(self):
        self.run_assert_equal(is_category_name, "# GIT*", "GIT")
        self.run_assert_equal(is_category_name, "#GIT*", "GIT")
        self.run_assert_equal(is_category_name, "  # GIT*", "GIT")

    def test_is_category_name_ending_here(self):
        self.run_assert_true(is_category_name_ending_here, " # END ")
        self.run_assert_true(is_category_name_ending_here, "# END")
        self.run_assert_false(is_category_name_ending_here, " # Don't END ")
        self.run_assert_false(is_category_name_ending_here, "#cat `find -name \"*gitignore*\"` > codytest.txt")

    def test_is_alias(self):
        result = is_alias("alias st='git status'  ")
        self.assertEqual(result,  {'name': 'st', 'command': 'git status'})

    def test_is_alias_for_none(self):
        result = is_alias(" st='git status'  ")
        self.assertIsNone(result)

    def test_is_bash_function(self):
        result = is_bash_function("cdproject() { cd $HOME/projects/$1; workon $1 ;}")
        self.assertEqual(result,  "cdproject")

    def test_is_bash_function_for_none(self):
        result = is_bash_function("blah blah blah")
        self.assertIsNone(result)

    def test_is_bash_function_end(self):
        pass

    def test_is_single_line_bash_function(self):
        result = is_single_line_bash_function("cdwkproject() { cd $WORK_PROJECTS/$1; workon $1 ;}")
        self.assertEqual(
            result,
            {'name': 'cdwkproject', 'command': 'cd $WORK_PROJECTS/$1; workon $1'}
        )


    def test_is_single_line_bash_function_for_none(self):
        result = is_single_line_bash_function(" blah blah blah")
        self.assertIsNone(result)

    def test_is_script(self):
        self.run_assert_equal(
            is_script,
            "alias nsh='$CODE_META_SCRIPTS_PATH/newshell.sh'",
            "sh"
        )

        self.run_assert_equal(
            is_script,
            "alias nsh='$CODE_META_SCRIPTS_PATH/newshell.py'",
            "py"
        )

        self.run_assert_equal(
            is_script,
            "alias nsh='$CODE_META_SCRIPTS_PATH/newshell.rb'",
            "rb"
        )

    def test_is_filepath(self):
        result = is_filepath('GITFLOW_AUTOMATION_SCRIPTS="$GITFLOW_AUTOMATION_PATH/scripts"')
        self.assertEqual(
            result,
            {'name': 'GITFLOW_AUTOMATION_SCRIPTS', 'path': "$GITFLOW_AUTOMATION_PATH/scripts"}
        )

    def test_gather_names_to_substitute(self):
        result = gather_names_to_substitute("$ONE/blah/blahhhh/$TWO/$THREE")
        self.assertEqual(result, ['ONE', 'TWO', 'THREE'])

    def test_construct_full_filepath(self):
        paths = {
            'ONE': 'path/to/one',
            'TWO': 'the/path/of/two',
            'THREE': 'threes/path'
        }
        result = construct_full_filepath("$ONE/blah/blahhhh/$THREE/gap/$TWO", paths)
        self.assertEqual(result, "path/to/one/blah/blahhhh/threes/path/gap/the/path/of/two")

    def test_grab_single_line_match(self):
        result = grab_single_line_match("alias pushfiles='$UPDATES_SCRIPTS_PATH/update_files.py push'")
        self.assertEqual(
            result,
            {'name': 'pushfiles', 'command': '$UPDATES_SCRIPTS_PATH/update_files.py push'}
        )

        result = grab_single_line_match("remakec() { rm $1; make $1 ;}")
        self.assertEqual(
            result,
            {'name': 'remakec', 'command': 'rm $1; make $1'}
        )

        result = grab_single_line_match('MPOS_SILO_PATH="$MPOS_SCRIPTS_PATH/mousepositionsilo.sh"')
        self.assertEqual(
            result,
            {'name': 'MPOS_SILO_PATH', 'path': '$MPOS_SCRIPTS_PATH/mousepositionsilo.sh'}
        )

    def test_grab_single_line_match_doesnt_grab_partial_match(self):
        result = grab_single_line_match("mystart() { ")
        self.assertIsNone(result)

    def run_assert_equal(self, callback, the_input, expectation):
        result = callback(the_input)
        self.assertEqual(result, expectation)

    def run_assert_true(self, callback, the_input):
        result = callback(the_input)
        self.assertTrue(result)

    def run_assert_false(self, callback, the_input):
        result = callback(the_input)
        self.assertFalse(result)
