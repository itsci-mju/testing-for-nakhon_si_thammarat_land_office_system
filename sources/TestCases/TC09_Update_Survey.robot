*** Settings ***
Library        SeleniumLibrary

*** Variables ***
${mess1}    กรุณากรอกเลขที่รังวัด
${mess2}    กรุณากรอกเลขที่รังวัด
*** Test Cases ***
Test
    IF  '${mess1}' == '${mess2}'
        Log To Console     PASS
        Log To Console     ${mess1}
    ELSE
        Log To Console     Fail
    END