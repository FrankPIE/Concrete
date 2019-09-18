cmake_minimum_required(VERSION 3.0.2)

function (concrete_utest_str_equal lhs rhs)
    if (${lhs} STREQUAL ${rhs})
        message(STATUS "${lhs} == ${rhs} -- Test OK")
    else()
        message(FATAL_ERROR "${lhs} == ${rhs} -- Test Error")
    endif()
endfunction(concrete_utest_str_equal)