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
$env.config.table.padding.right = 5
$env.config.table.header_on_separator = true

$env.config.filesize.unit = 'binary'
$env.config.cursor_shape.emacs = "line"        

source prompt.nu

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

$env.config.color_config = {
	row_index: light_gray_italic,
	record: red_bold,
	empty: red_bold,
	closure: green,
	range: white,
	int: white,
	search_result: { bg: red, fg: white },
	leading_trailing_space_bg: { attr: n },
	nothing: white,
	hints: { bg: light_yellow},
	filesize: white_italic,
	bool: white_italic,
	float: white_italic,
	binary: white_italic,
	duration: white,
	header: white_bold,
	string: white,
	cell-path: red,
	list: white,
	datetime: white_italic,
	glob: red_bold,
	separator: dark_gray,
	block: white,
    
    # shapes
    shape_keyword: red_bold,
	shape_closure: green_bold,
    shape_matching_brackets: { attr: underline },
	shape_filepath: blue,
	shape_directory: blue,
	shape_signature: green_bold,
    shape_redirection: purple_bold,
    shape_vardecl: purple,
    shape_list: cyan_bold,
	shape_externalarg: white,
	shape_table: blue_bold,
	shape_pipe: purple_bold,
	shape_string_interpolation: cyan_bold,
	shape_block: blue_bold,
	shape_bool: white_italic,
	shape_int: white_italic,
    shape_float: white_italic,
	shape_binary: white_italic,
    shape_globpattern: white_italic,
	shape_glob_interpolation: white_italic,
	shape_string: white,
	shape_custom: white_bold,
	shape_external: white,
	shape_literal: blue,
	shape_external_resolved: light_yellow_bold,
	shape_flag: blue_italic,
	shape_match_pattern: green,
	shape_datetime: cyan_bold,
	shape_range: yellow_bold,
	shape_operator: white_bold,
	shape_internalcall: white_bold,
	shape_record: white_bold,
	shape_variable: purple,
	shape_raw_string: light_purple,
	shape_nothing: red
	shape_garbage: { fg: white, bg: red, attr: bold },
}

$env.PROMPT_INDICATOR = $"(ansi white_bold)$ ";
$env.PROMPT_COMMAND_RIGHT = "";
$env.LS_COLORS = "di=0;34:ln=0;35:ex=0;32:*.7z=3;34:*.ace=3;34:*.alz=3;34:*.apk=3;34:*.arc=3;34:*.arj=3;34:*.bz=3;34:*.bz2=3;34:*.cab=3;34:*.cpio=3;34:*.crate=3;34:*.deb=3;34:*.drpm=3;34:*.dwm=3;34:*.dz=3;34:*.ear=3;34:*.egg=3;34:*.esd=3;34:*.gz=3;34:*.jar=3;34:*.lha=3;34:*.lrz=3;34:*.lz=3;34:*.lz4=3;34:*.lzh=3;34:*.lzma=3;34:*.lzo=3;34:*.pyz=3;34:*.rar=3;34:*.rpm=3;34:*.rz=3;34:*.sar=3;34:*.swm=3;34:*.t7z=3;34:*.tar=3;34:*.taz=3;34:*.tbz=3;34:*.tbz2=3;34:*.tgz=3;34:*.tlz=3;34:*.txz=3;34:*.tz=3;34:*.tzo=3;34:*.tzst=3;34:*.udeb=3;34:*.war=3;34:*.whl=3;34:*.wim=3;34:*.xz=3;34:*.z=3;34:*.zip=3;34:*.zoo=3;34:*.zst=3;34"

use completions/completions.nu *