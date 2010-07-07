function fail {
    echo -n '['
    tput setf 4
    echo -n FAIL
    tput setf 0
    echo -n '] '
    echo $1
}

fail david