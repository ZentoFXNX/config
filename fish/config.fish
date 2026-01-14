if status is-interactive
    if test "$TERM_PROGRAM" != "vscode"
        set rand (math (random) % 10)
        if test $rand -eq 0
            pokego -r 1-8 -s --no-title
        else
            pokego -r 1-8 --no-title
        end
    end
end     

set -gx PATH "/Library/Frameworks/Python.framework/Versions/3.11/bin" $PATH

