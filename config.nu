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


$env.PROMPT_INDICATOR = "$ ";
$env.PROMPT_COMMAND_RIGHT = "";
$env.LS_COLORS = "di=1;34:ln=1;36:ex=0;32:*.7z=3;34:*.ace=3;34:*.alz=3;34:*.apk=3;34:*.arc=3;34:*.arj=3;34:*.bz=3;34:*.bz2=3;34:*.cab=3;34:*.cpio=3;34:*.crate=3;34:*.deb=3;34:*.drpm=3;34:*.dwm=3;34:*.dz=3;34:*.ear=3;34:*.egg=3;34:*.esd=3;34:*.gz=3;34:*.jar=3;34:*.lha=3;34:*.lrz=3;34:*.lz=3;34:*.lz4=3;34:*.lzh=3;34:*.lzma=3;34:*.lzo=3;34:*.pyz=3;34:*.rar=3;34:*.rpm=3;34:*.rz=3;34:*.sar=3;34:*.swm=3;34:*.t7z=3;34:*.tar=3;34:*.taz=3;34:*.tbz=3;34:*.tbz2=3;34:*.tgz=3;34:*.tlz=3;34:*.txz=3;34:*.tz=3;34:*.tzo=3;34:*.tzst=3;34:*.udeb=3;34:*.war=3;34:*.whl=3;34:*.wim=3;34:*.xz=3;34:*.z=3;34:*.zip=3;34:*.zoo=3;34:*.zst=3;34"