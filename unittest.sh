#!/bin/sh

# opts
test_suite_dir=$1;
debug=0
enable_test_output=0

# suite global
test_case_pattern=test_case*.sh

list_tests(){
    local file_name="$1";
    cat "$file_name" | grep ^test_.*\(\)\{ | cut -d \( -f1;
};

run_function(){
    local name=$1;
    echo -n .;
    if(($debug)); then
        echo "  Running function: $name";
    fi;
    if(($enable_test_output)); then
        $name;
    else
        $name > /dev/null 2>&1;
    fi;
    unset -f $name;
}


run_test_case(){
    local test_case_file="$1";

    local unittest_error_count=0;
    local unittest_error_function_list="";
    local unittest_current_function="";

    if(($debug)); then
        echo "Running ${test_case_file}";
    fi;
    . "${test_case_file}";

    tests=$(list_tests "${test_case_file}");

    # Running each test;
    for t in $tests; do
        unittest_current_function=$t;
        run_function $t;
    done;
    echo
    echo We have \#$unittest_error_count errors;
    echo Errors: $unittest_error_function_list;
}

run_test_suite(){
    local dir=$1;
    for i in $dir/$test_case_pattern; do
        if [ -f "$i" ]; then
            run_test_case "$i";
        fi;
    done;
}

record_error(){
    unittest_error_count=`expr $unittest_error_count + 1`;
    unittest_error_function_list="$unittest_error_function_list \n $unittest_current_function (err: $@);";
}

assert_equal(){
    if [ "${1}" != "${2}" ]; then
        record_error "assert_equal '$1' != '$2'";
    fi;
};

assert_not_equal(){
    if [ "${1}" -eq "${2}" ]; then
        record_error "assert_not_equal: '$1' == '$2'";
    fi;
}

assert_less_than(){
    echo TODO;
}

assert_greater_than(){
    echo TODO;
}

assert_less_than_or_equal(){
    echo TODO;
}

assert_greater_than_or_equal(){
    echo TODO;
}

assert_in(){
    echo "${2}" | grep "${1}";
    if [ $? != 0 ]; then
        record_error "assert_in: '${1}' not in  '${2}'";
    fi;
}


_mocked(){
    local cmd=$1;
    shift;

    local len=$(($#-1))
    local echo_=${@:1:$len}
    shift $len;

    local ret=$1;
    
    echo "${echo_}";
    return $ret;
}

build_mock(){
    local cmd=$1;
    eval "$cmd(){
        _mocked \"$1\" \"$2\" $3;
        return \$?;
    }";
}

unmock(){
    unset -f $1;
}


if [ "${test_suite_dir}" != "" ]; then
    run_test_suite $test_suite_dir;
fi;

