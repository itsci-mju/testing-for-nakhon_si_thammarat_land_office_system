*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library          DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Add_Questions.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC05_Add_Questions
    Customer Login
    Start Video Recording   alias=None  name=TC05_Add_Questions  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC05_Add_Questions.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${TopQuestion}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${DetailQuestion}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
                IF     ${i} >= 3
                    Go To     ${Questions_URL}
                 END
             Add Questions Page      ${TopQuestion}    ${DetailQuestion}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},4).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC05_Add_Questions/Screenshot/${testcaseData}.png

             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'     ${Empty}        ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},4).value}"     -


             Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC05_Add_Questions_result.xlsx
    Close All Excel Documents
    CloseWebBrowser
    Stop Video Recording      alias=None

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
    Input Text      ${AQ_TopQuestion}     ${TopQuestion}
    Input Text      ${AQ_DetailQuestion}      ${DetailQuestion}
    Click Element   ${Cilk_button}
    Sleep  5s

Check Error page
    [Arguments]     ${Actual_Result}
        Log To Console  ${testcaseData}

        IF  "${testcaseData}" == "TD003"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_ques_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${message_ques_1}
                END
        ELSE IF  "${testcaseData}" == "TD004"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_ques_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${message_ques_1}
                END
        ELSE IF  "${testcaseData}" == "TD010"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_ques}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${message_ques}
                END
        ELSE IF  "${testcaseData}" == "TD013"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_detail_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${message_detail_1}
                END
        ELSE IF  "${testcaseData}" == "TD014"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_detail_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${message_detail_1}
                END
        ELSE IF  "${testcaseData}" == "TD020"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_detail}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${message_detail}
                END
        ELSE
            ${get_message}   Run keyword and ignore error    Handle Alert    timeout=5s
            ${message}     Convert To String   ${get_message}[1]
        END

    # "---------------------------------------------------"
        IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
        END

        Log To Console      ${Status}
        Log To Console      ${message}

      [Return]   ${Status}  ${message}



