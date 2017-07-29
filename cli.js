var inquirer = require('inquirer');

// override console log to use print like python
function print(text) {
    console.log(text);
}

// COLORS
//  need to come up with a readable color scheme:
//  https://www.npmjs.com/package/cli-color


// GENERAL SETUP
const EXIT_SELECTION = '* exit *'

// this quiets a warning: turn it on when script is ready to be published
//   https://stackoverflow.com/questions/40500490/what-is-unhandled-promise-rejection
//process.on('unhandledRejection', rejection => function(){});

// END GENERAL SETUP


// an example of what we're parsing:

// # GIT*
// alias co='git checkout $1'
// cmpush() { git cm "$1"; git push ;}
// cmpushall() { git add -A; git cm "$1"; git push ;}
// # END

// # UPDATES*
// alias pushfiles='$UPDATES_SCRIPTS_PATH/update_files.py push'
// alias pullfiles='$UPDATES_SCRIPTS_PATH/update_files.py pull'
// alias updateall='$UPDATES_SCRIPTS_PATH/pull_and_update_all_projects.py'
// # END

// # PYTHON*
// alias setupnstl='python setup.py install'
// alias setupdev='python setup.py develop'
// alias unittest='python -m unittest discover $@'
// # END

var MAPPER = {
    git: {
        co: {type: 'alias', command: 'git checkout $1'},
        cmpush: {type: 'function', command: 'git cm "$1"; git push '},
        cmpushall: {type: 'function', command: 'git add -A; git cm "$1"; git push'}
    },
    updates: {
        pushfiles: {type: 'python script', command: '$UPDATES_SCRIPTS_PATH/update_files.py push'},
        pullfiles: {type: 'python script', command: '$UPDATES_SCRIPTS_PATH/update_files.py pull'},
        updateall: {type: 'python script', command: '$UPDATES_SCRIPTS_PATH/pull_and_update_all_projects.py'}
    },
}

function parse_filepath_from_command(command_string) {
    let array = command_string.split(' ');
    return array[0];
}

// test parse_filepath_from_command
var EXPECTATION = '$UPDATES_SCRIPTS_PATH/update_files.py'
console.assert(parse_filepath_from_command('$UPDATES_SCRIPTS_PATH/update_files.py push arg2 arg3') == EXPECTATION)
console.assert(parse_filepath_from_command('$UPDATES_SCRIPTS_PATH/update_files.py push') == EXPECTATION)
console.assert(parse_filepath_from_command('$UPDATES_SCRIPTS_PATH/update_files.py') == EXPECTATION)


function gatherDrilldownRequirements(some_object) {
    // this should probably be refactored to use arrays of objects

    /*
    takes category data like

        git: {
            co: {type: 'alias', command: 'git checkout $1'},
            cmpush: {type: 'function', command: 'git cm "$1"; git push '},
            cmpushall: {type: 'function', command: 'git add -A; git cm "$1"; git push'}
        }
    */

    let results_options = []
    let results = {}
    // https://stackoverflow.com/questions/8312459/iterate-through-object-properties
    for (let command_name in some_object) {
        if (some_object.hasOwnProperty(command_name)) {
            // attribute_dict looks like {type: 'alias', command: 'git checkout $1'} etc
            let attribute_dict = some_object[command_name];
            if (attribute_dict.type == 'python script') {

                results_options.push(command_name)

                // because in this case, it's a command like $UPDATES_SCRIPTS_PATH/update_files.py push
                // the wrapper parse_filepath_from_command removes the arguments like 'push' from above
                let filepath = parse_filepath_from_command(attribute_dict.command);

                // then get the source from filepath:
                //   https://docs.nodejitsu.com/articles/file-system/how-to-read-files-in-nodejs/
                // let source = read_file_func(filepath);
                results[command_name] = "the source code of the file goes here: get from " + filepath// the drilldown
            }

        }
    }
    return {'options': results_options, 'extra_data': results}
}


function generate_spaces(number_of_spaces) {
    // https://stackoverflow.com/questions/1877475/repeat-character-n-times
    let spaces = Array(number_of_spaces + 1).join(" ")
    return spaces
}


function generate_command_option(command, command_data, longest_total_length) {
    console.log("in generate_command_option");
    console.log(command_data);
    let type = command_data.type;
    let this_length = command.length + type.length;
    let spaces_needed = longest_total_length - this_length;
    let option = command + ': ' + type + ' - ' + generate_spaces(spaces_needed) + command_data.command;
}

// first, read and parse the bash_profile file and get categories and the commands under them
let category_choices = ['git', 'updates', 'python', 'AWS shortcuts', 'temp', 'work_scripts'];
category_choices.push(EXIT_SELECTION);

inquirer.prompt([
    {
        type: 'list',
        message: 'Pick a category to see more detail',
        choices: category_choices,
        name: 'category'
    }
]).then(function(response) {
    let chosen_category = response.category;

    if (chosen_category == EXIT_SELECTION) {
        // https://stackoverflow.com/questions/5266152/how-to-exit-in-node-js
        print('blah')
        return 0
        process.exit()
    }

    // this is the data for the category like git, update, etc
    let COMMANDS_MAP = MAPPER[chosen_category];

    // a list of the commands for that object, like co, cmpush, cmpushall, etc
    let commands_list = Object.keys(COMMANDS_MAP);

    // print report
    // TODO: refactor into a function
    console.log('\n');
    for (let command of commands_list) {
        let dataset = COMMANDS_MAP[command]
        console.log(`${dataset.type}: "${command}"\n`);
        console.log(`    ${dataset.command}\n`);
    }

    let drill_down_requirements = gatherDrilldownRequirements(COMMANDS_MAP);

    // print('\n\nthe drill down data:');
    // console.log(drill_down_requirements);
    // print('\n\n');

    if (drill_down_requirements.options.length > 0) {

        inquirer.prompt([
            {
                type: 'list',
                message: 'Pick a command to drill down more info:\n',
                choices: drill_down_requirements.options,
                name: 'command_chosen'
            }
        ]).then(function(response) {
            let chosen_command = response.command_chosen;
            print('\n' + drill_down_requirements.extra_data[chosen_command]);
        });
    }
});
