*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library          DebugLibrary
Resource    ../Resources/RS_Edit_Questions.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC06_Edit_Questions
    Customer Login
    Open Excel Document     TestData//TC06_Edit_Questions.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
             ${TopQuestion}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${DetailQuestion}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
                IF     ${i} >= 3
                    Go To     ${Questions_URL}
                 END
             Add Questions Page      ${TopQuestion}    ${DetailQuestion}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}   Check Error page     ${eclin.cell(${i},4).value}
             Log To Console    ${Status_1}
             Log To Console    ${message_1}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      Pass            Fail
             ${message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'Pass'      No Error          Not Found Alert
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},4).value}"     -


             Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC06_Edit_Questions_result.xlsx
    Close All Excel Documents
    CloseWebBrowser

*** Keywords ***
Customer Login
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   khun123
    Input Password  ${pass_locate}   123456
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}
    Sleep  1s
    Go To    ${Questions_URL}

Add Questions Page
    [Arguments]     ${TopQuestion}    ${DetailQuestion}
    Input Text      ${EQ_TopQuestion}     ${TopQuestion}
    Input Text      ${EQ_DetailQuestion}      ${DetailQuestion}
    Click Element   ${Cilk_button}
    Sleep  5s

Check Error page
    [Arguments]     ${ActualResult}
    ${get_message}   Run keyword and ignore error    Handle Alert       timeout=10 s     action=ACCEPT
    ${Status}  Run Keyword And Return Status    Should Be Equal     ${ActualResult}     ${get_message}[1]
    [Return]   ${Status}  ${get_message}[1]