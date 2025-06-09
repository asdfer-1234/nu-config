# TODO: fix parser errors from undeclared variables

use goodies.nu *

const path_separator = $"(ansi blue)/";

def path-separator-decorate [] {
    str join $path_separator | str append $path_separator
}

def decorated-pwd [git_repo] {
    let git_path = if $git_repo != null { ($git_repo.git_dir | path sp) }
    
    let home_path = $nu.home-path | path sp
    pwd
    | path sp
    | each {{style: (ansi blue) name: $in}}
    | if $git_path != null and (list starts-with ($in | get name) $git_path) {
        enumerate | each { if $in.index < ($git_path | length) {$in.item | update style (ansi green)} else {$in.item} }
    } else {
        $in
    }
    | (
        let original_path = $in;
        if ($original_path | is-empty) {
            $path_separator
        } else {
            # by current version of nushell this collects the entire $path_abbreations variable to filter it all out
            # may nushell fast adopt streams in variables
            # even if i am only going to have like 10 path abbreviations
            let eligible_abbreviations = $path_abbreviations | filter {list starts-with ($original_path | get name) ($in.path | path sp)}
            if ($eligible_abbreviations | is-empty) {
                $original_path
                | each {$in.style + $in.name}
                | path-separator-decorate
                | str prepend $path_separator
            } else {
                let abbreviation = $eligible_abbreviations.0;
                $original_path
                | last (($original_path | length) - ($abbreviation.path | path sp | length))
                | each {$in.style + $in.name}
                | prepend $abbreviation.abbreviated
                | path-separator-decorate
            }
        }
    )
}

def last-exit-code [] {
    if $env.LAST_EXIT_CODE != 0 {$"(ansi red_bold)!($env.LAST_EXIT_CODE)(ansi reset)"}
}

def git-status [git_repo] {
    
    if $git_repo != null {
        mut prompt = ""
        
        $prompt += $"(ansi yellow)($git_repo.branch) "

        $git_prompt | reduce --fold [] {|it add|
            let count = $git_repo.changes | get $it.variable;
            if $count != 0 {
                $it | append ($count | do $it.closure)
            } else {
                $it
            }
        }

        for status in $git_prompt {
            let count = $git_repo.changes | get $status.variable
            if $count != 0 {
                $prompt += ($count | do $status.closure) + " "
            }
        }
        $prompt
    }
}

def prompt-command [] {
    let git_repo = git-status-json | from json;
    [
        (last-exit-code)
        (git-status $git_repo)
        (decorated-pwd $git_repo)
    ]
    | filter {$in != null}
    | str join "\n"
    | str append "\n"
}

$env.PROMPT_COMMAND = {prompt-command};