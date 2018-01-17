import unittest

from scriptamajig.main import (
    is_category_name,
    is_category_name_ending_here,
    is_alias,
    is_bash_function
)


class TestParsingFunctions(unittest.TestCase):

    def test_is_category_name(self):
        self.run_assert_equal(is_category_name, "# GIT*", "GIT")
        self.run_assert_equal(is_category_name, "#GIT*", "GIT")
        self.run_assert_equal(is_category_name, "  # GIT*", "GIT")

    def test_is_category_name_ending_here(self):
        self.run_assert_true(is_category_name_ending_here, " # END ")
        self.run_assert_true(is_category_name_ending_here, "# END")
        self.run_assert_false(is_category_name_ending_here, " # Don't END ")

    def test_is_alias(self):
        result = is_alias("alias st='git status'  ")
        self.assertEqual(result,  {'name': 'st', 'command': 'git status'})

    def test_is_bash_function(self):
        result = is_bash_function("cdproject() { cd $HOME/projects/$1; workon $1 ;}")
        self.assertEqual(result,  "cdproject")

    def run_assert_equal(self, callback, the_input, expectation):
        result = callback(the_input)
        self.assertEqual(result, expectation)

    def run_assert_true(self, callback, the_input):
        result = callback(the_input)
        self.assertTrue(result)

    def run_assert_false(self, callback, the_input):
        result = callback(the_input)
        self.assertFalse(result)
