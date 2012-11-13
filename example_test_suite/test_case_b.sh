#!/bin/sh

test_b1(){
    echo "abc";
    assert_equal 1 1;
    assert_equal 1 2;
    return 0;
}
