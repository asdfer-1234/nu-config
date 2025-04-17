use std *

$env.config.buffer_editor = "/usr/bin/code"


$env.config.show_banner = false

if $nu.is-interactive {
    blear
}



let git_prompt = [
    [variable, closure];
    [files_added, {$"(ansi green)+($in)"}]
    [files_deleted, {$"(ansi red)-($in)"}]
    [files_modified, {$"(ansi blue)M($in)"}]
    [files_renamed, {$"(ansi blue)R($in)"}]
    [files_copied, {$"(ansi green)Copied ($in)"}]
    [files_ignored, {$"(ansi red)Ignored ($in)"}]
    [files_untracked, {$"(ansi white)Untracked ($in)"}]
    [files_typechange, {$"(ansi white)Typechange ($in)"}]
    [files_unreadable, {$"(ansi white)Unreadable ($in)"}]
    [files_conflicted, {$"(ansi white)Conflicted ($in)"}]
    [files_unmodified, {$"(ansi white)Unmodified ($in)"}]
]

let path_abbreviations = [
    [path, abbreviated];
    [/home/asdfer, $"(ansi purple)~"]
];


# table.*
# table_mode (string):
# One of: "default", "basic", "compact", "compact_double", "heavy", "light", "none", "reinforced",
# "rounded", "thin", "with_love", "psql", "markdown", "dots", "restructured", "ascii_rounded",
# or "basic_compact"
# Can be overridden by passing a table to `| table --theme/-t`
$env.config.table.mode = "light"
$env.config.footer_mode = "auto"
$env.config.table.padding.left = 0
$env.config.table.padding.right = 1
$env.config.table.header_on_separator = true

$env.config.filesize.unit = 'binary'
$env.config.cursor_shape.emacs = "line"        

use prompt.nu prompt-command

$env.last = null

$env.config.hooks.display_output = {
    if (term size).columns >= 100 {
        table -e
    } else {
        table
    } | print
    $env.last = $in # nushell mutable caputure when so i don't have to use $env!
    cd -P .
}

def ch [] {
    $env.last
}

# Copied and added --wrapped from
# https://github.com/nushell/nushell/discussions/9584#discussioncomment-6370296
def --wrapped sudo [...command: string] {
    print $command
    ^sudo nu --stdin --commands ($command | str join ' ')
}

# Copied and added --wrapped from
# https://github.com/nushell/nushell/issues/247#issuecomment-2209629106
def --wrapped disown [...command: string] {
    sh -c '"$@" </dev/null >/dev/null 2>/dev/null & disown' $command.0 ...$command
}

$env.PROMPT_COMMAND = {prompt-command};
$env.PROMPT_INDICATOR = "$ ";
$env.PROMPT_COMMAND_RIGHT = "";