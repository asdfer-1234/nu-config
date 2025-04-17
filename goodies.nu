export def --wrapped "str replace-start" [find: string replace: string ...rest] {
    if ($in | str starts-with $find) {
            str replace $find $replace ...$rest
    } else {$in}
}

export def "list starts-with" [list: list start: list] {
    ($list | length) >= ($start | length) and ($list | zip $start | all {|x| $x.0 == $x.1})
}

export def "path sp" []: string -> list<string> {
    path split | skip
}

export def "str append" [a: string]: string -> string {
    $in + $a
}

export def "str prepend" [a: string]: string -> string {
    $a + $in
}
