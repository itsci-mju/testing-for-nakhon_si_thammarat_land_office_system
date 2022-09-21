*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library         DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Add_Answer.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC10_Add_Answer
    Customer Login
    Start Video Recording   alias=None  name=TC10_Add_Answer  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC10_Add_Answer.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
             ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${aad_answer}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
                 IF     ${i} >= 3
                    Go To    ${Add_Answer_URL}
                 END
             Add Answer Page      ${aad_answer}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},3).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC10_Add_Answer/Screenshot/${testcaseData}.png

             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},3).value}"     -


             Write Excel Cell        ${i}    4       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    5       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC10_Add_Answer_result.xlsx
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
    Sleep  2s
    Go To    ${Add_Answer_URL}

Add Answer Page
    [Arguments]     ${aad_answer}
    Input Text      ${Answer}      ${aad_answer}
    Click Element   ${Cilk_Button}
    Sleep  5s

Check Error page
    [Arguments]     ${ActualResult_1}
    Log To Console  ${testcaseData}
    IF  "${testcaseData}" == "TD003"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_alert}
        IF  '${checkVisible}' == 'True'
                ${message1}  Get Text  ${message_alert}
                ${message}     Convert To String  ${message1}
        END
    ELSE IF  "${testcaseData}" == "TD004"
          ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${message_alert}
        IF  '${checkVisible}' == 'True'
                ${message1}  Get Text  ${message_alert}
                ${message}     Convert To String  ${message1}
        END
    ELSE
           ${get_message}   Run keyword and ignore error    Handle Alert    timeout=5s
           ${message}     Convert To String   ${get_message}[1]
    END
        ${Actual_Result}     Convert To String   ${ActualResult_1}
    IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
    END

        Log To Console      ${message}
        Log To Console      ${Status}
      [Return]   ${Status}  ${message}