*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC02_Login
    Begin Webpage
    Start Video Recording   alias=None  name=TC02_Login  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC02_Login.xlsx     doc_id=TestData
    ${excel}    Get Sheet   TestData
    FOR    ${i}    IN RANGE   2    ${excel.max_row+1}
            ${tcid}     Set Variable if    '${excel.cell(${i},1).value}'=='None'    ${Empty}     ${excel.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
            ${user}     Set Variable if    '${excel.cell(${i},2).value}'=='None'    ${Empty}     ${excel.cell(${i},2).value}
            ${pass}     Set Variable if    '${excel.cell(${i},3).value}'=='None'    ${Empty}     ${excel.cell(${i},3).value}

            Login Page      ${user}    ${pass}

             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${excel.max_row}    Check Error page     ${excel.cell(${i},4).value}

             ${Status_Actual}       Set Variable if    ${i}<=${excel.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
              Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC02_Login/Screenshot/${testcaseData}.png


             ${get_message}       Set Variable if    ${i}<=${excel.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${excel.cell(${i},4).value}"     -


             Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Suggestion}        sheet_name=TestData
    END
    Save Excel Document       Result/WriteExcel/TC02_Login_result.xlsx
    Close All Excel Documents
    CloseWebBrowser
    Stop Video Recording      alias=None

*** Keywords ***
Begin Webpage
    Open Browser            ${Login URl}     ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed      0.5s

Login Page
    [Arguments]   ${username}    ${password}
    Input Text      ${user_locate}   ${username}
    Input Text      ${pass_locate}     ${password}
    Click Element    ${btn_login}

LogOut
    Wait Until Element Is Visible  ${Cilk_LogOut}
    Click Element  ${Cilk_LogOut}
    Run keyword and ignore error    Handle Alert    timeout=5s   action=ACCEPT
    Run keyword and ignore error    Handle Alert    timeout=5s   action=ACCEPT
    Go to   ${Login URl}

check text page
    ${message}    Check Page Login   ${text_page}
    Run keyword and ignore error    LogOut
    [Return]    ${message}
check page message
    ${message}  Get Text  ${text_error}
    Run keyword and ignore error    LogOut
    [Return]    ${message}
get text alert
    ${get_message}   Run keyword and ignore error    Handle Alert    timeout=5s
    ${message}     Convert To String   ${get_message}[1]
    Run keyword and ignore error    LogOut
    [Return]    ${message}

Check Error page
    [Arguments]     ${Actual_Result}
        Log To Console  ${testcaseData}
    # "---------------------------------------------------"
    IF  "${testcaseData}" == "TD001"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD002"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD003"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD004"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD006"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD007"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD010"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD012"
        ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD013"
         ${message}  check page message
    ELSE IF  "${testcaseData}" == "TD015"
         ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD018"
         ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD019"
         ${message}  check page message
    ELSE IF  "${testcaseData}" == "TD008"
         ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD009"
         ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD010"
         ${message}  check text page
    ELSE IF   "${testcaseData}" == "TD013"
         ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD017"
         ${message}  check text page
    ELSE IF  "${testcaseData}" == "TD020"
         ${message}  check page message
    ELSE IF  "${testcaseData}" == "TD021"
         ${message}  check text page
    ELSE
         ${message}  get text alert
    END

    IF  '${Actual_Result.strip()}' == '${message.strip()}'
        Set Suite Variable  ${Status}  True
    ELSE
        Set Suite Variable  ${Status}  False
    END

    Log To Console      ${Status}

    [Return]   ${Status}  ${message}

Check Page Login
    [Arguments]  ${locator}
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${locator}     30s
    ${Result}  Set Variable if    '${Status}'=='True'      เข้าสู่ระบบเรียบร้อยแล้ว        เข้าสู่ระบบไม่สำเร็จ
    [Return]     ${Result}

