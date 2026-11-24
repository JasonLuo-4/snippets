# Play a sound when a your CMSC 14300 Homeworks compile command or run command 
#   fails. Add this code snippet to the end of your ~/.zshrc file.
#   I recommend faahh for the sound effect. 
# Because in our homework assignment, compilation is always "make test1" and 
#   "./test1". So my if conditions is checking if the last command ($1) 
#   matches those two expressions. prexec_functions is a list of functions that
#   will be executed immediately before the shell execuate commands. 
#   precmd_functions is a list of functions that will be executed immediately
#   before the prompt appears. Which is the same as immediately after the last 
#   command finishes. zsh called them "hook functions".
#   $? is the exit code. 
#   $1 is your command input. 
_fail_sound_cmd="" # create a variable first
_fail_sound_preexec() {
    # we can only get $1 here, not in precmd functions.
    _fail_sound_cmd=$1
}
_fail_sound_precmd() {
    local code=$?  # must be the FIRST line, before anything changes $? 
    local cmd=$_fail_sound_cmd
    # we need to reset this back to empty string.
    # otherwise when we hit enter to no input, the exit code won't change
    # but we will hear the sound again. resetting makes sure the sound only
    # trigger once for each failure.
    _fail_sound_cmd=""  
    local folder=$PWD
    # [[]] is syntax for string expressoin true/false checking.
    # (()) is syntax for numbers comparison true/false checking
    if [[ ($cmd == "make test1" || $cmd == "./test1") && 
        $folder == "</path/to/your/cmsc14300/homework/folder>"* ]] &&
        (( $code != 0 && $code != 130 ))
    then
    # &!
    # & means run the command in background.
    # but programs running in background in will display some texts when finish.
    # ! tells zsh to just forget about this process. So the sound will be played
    # but our terminal won't display any information.
    # -v 0.1 is for volume adjustment.
    afplay -v 0.1 <path/to/the/sound_effect/> &!
    fi 
}
preexec_functions+=(_fail_sound_preexec)
precmd_functions+=(_fail_sound_precmd)
