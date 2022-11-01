*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library        Collections
Library        ScreenCapLibrary
Resource    ../Resources/RS_Register.robot

*** Test Cases ***
TC03_Register
    Begin Webpage
    Start Video Recording   alias=None  name=TC03_Register  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC03_Register.xlsx     doc_id=TestData
    ${excel}    Get Sheet   TestData
    FOR    ${i}    IN RANGE   2    ${excel.max_row+1}
            ${tcid}     Set Variable if    '${excel.cell(${i},1).value}'=='None'    ${Empty}     ${excel.cell(${i},1).value}
             Set Suite Variable  ${testcase}  ${tcid}
            ${user}     Set Variable if    '${excel.cell(${i},2).value}'=='None'    ${Empty}     ${excel.cell(${i},2).value}
            ${pass}     Set Variable if    '${excel.cell(${i},3).value}'=='None'    ${Empty}     ${excel.cell(${i},3).value}
            ${Compassword}     Set Variable if    '${excel.cell(${i},4).value}'=='None'    ${Empty}     ${excel.cell(${i},4).value}
            ${Fristname}     Set Variable if    '${excel.cell(${i},5).value}'=='None'    ${Empty}     ${excel.cell(${i},5).value}
            ${Lastname}     Set Variable if    '${excel.cell(${i},6).value}'=='None'    ${Empty}     ${excel.cell(${i},6).value}
            ${Gmail}     Set Variable if    '${excel.cell(${i},7).value}'=='None'    ${Empty}     ${excel.cell(${i},7).value}
            ${Idcard}     Set Variable if    '${excel.cell(${i},8).value}'=='None'    ${Empty}     ${excel.cell(${i},8).value}
            ${PROFILE}     Set Variable if    '${excel.cell(${i},9).value}'=='None'    ${Empty}     ${excel.cell(${i},9).value}
             Set Suite Variable  ${add_img}  ${PROFILE}
             IF     ${i} >= 3
                 Go To      ${Register_URL}
             END

             Register Page      ${user}    ${pass}  ${Compassword}  ${Fristname}    ${Lastname}    ${Gmail}   ${Idcard}  ${PROFILE}

             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${excel.max_row}    Check Error page     ${excel.cell(${i},10).value}
             Log To Console    ${Status_1}
             Log To Console    ${message_1}
             ${Status_Actual}       Set Variable if    ${i}<=${excel.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
              Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC03_Register/Screenshot/${testcase}.png

             ${get_message}       Set Variable if    ${i}<=${excel.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'     ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${excel.cell(${i},10).value}"     -

             Write Excel Cell        ${i}    11       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    12      value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    13       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    14       value=${Suggestion}        sheet_name=TestData
    END
    Save Excel Document       Result/WriteExcel/TC03_Register_result.xlsx
    Close All Excel Documents
    Close Browser
    Stop Video Recording      alias=None

*** Keywords ***
Begin Webpage
    Open Browser            ${Register_URL}      ${Browser}
    Maximize Browser Window
    Set Selenium Speed      1s

Register Page
    [Arguments]   ${username}    ${password}    ${Compassword}  ${Fristname}
    ...         ${Lastname}     ${Gmail}    ${Idcard}   ${PROFILE}
    Input Text      ${RE_Username}    ${username}
    Input Text      ${RE_Password}      ${password}
    Input Text      ${RE_Compassword}   ${Compassword}
    Input Text      ${RE_Fristname}     ${Fristname}
    Input Text      ${RE_Lastname}      ${Lastname}
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Input Text      ${RE_Gmail}         ${Gmail}
    Input Text      ${RE_Idcard}        ${Idcard}
    Run keyword If   '${PROFILE}'!='${Empty}'    Choose File        id=m_image       ${PROFILE}
    IF  "${testcase}" == "TD069"
        ${get_message}   Run keyword and ignore error    Handle Alert    LEAVE
        Run keyword and ignore error    Handle Alert
        ${message}     Convert To String    ${get_message}[1]
        Set Suite Variable  ${add_img}  ${message}
    END
    Click Element    ${RE_Cilkbutton}

Check Error page
    [Arguments]     ${Actual_Result}
         Log To Console  ${testcase}

         IF  "${testcase}" == "TD069"
            ${message}     Convert To String    ${add_img}
         ELSE
            ${get_message}   Run keyword and ignore error    Handle Alert    LEAVE
            Run keyword and ignore error    Handle Alert
            ${message}     Convert To String   ${get_message}[1]
         END

    # "---------------------------------------------------"
        IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
        END

        Log To Console      ${Status}
      [Return]   ${Status}  ${message}



