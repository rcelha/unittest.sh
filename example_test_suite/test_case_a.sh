#!/bin/sh

test_a_1(){
    assert_equal 1 2;
    return 0;
}

test_a_2(){
    assert_equal "Oi mundo" "Tchau mundo"
    return 0;
}

test_ls(){
    echo 'test ls';
    ls /blado;
    ret=$?;
    assert_equal $ret 0;
    assert_not_equal $ret 2;
}

test_optparse_calls(){
    MOCK_OUTPUT=`cat <<EOF
usr
bin
sbin
EOF
`;
    build_mock "ls" "${MOCK_OUTPUT}" 0;
    ls ~;
    echo $?
    unmock ls;
    ls;
}
