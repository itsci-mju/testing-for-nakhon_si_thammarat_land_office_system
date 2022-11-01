*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library         DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Add_Survey.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC08_Add_Survey
    Officer Login
    Start Video Recording   alias=None  name=TC08_Add_Survey   fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC08_Add_Survey.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${Number_Survey}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${Status_Number}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
             ${Surveyor}     Set Variable if    '${eclin.cell(${i},4).value}'=='None'    ${Empty}     ${eclin.cell(${i},4).value}
             ${Fritname}     Set Variable if    '${eclin.cell(${i},5).value}'=='None'    ${Empty}     ${eclin.cell(${i},5).value}
             ${Lastname}     Set Variable if    '${eclin.cell(${i},6).value}'=='None'    ${Empty}     ${eclin.cell(${i},6).value}
                IF     ${i} >= 3
                    Go To     ${AddSurvey_URL}
                END
             Add Survey Page      ${Number_Survey}    ${Status_Number}   ${Surveyor}   ${Fritname}    ${Lastname}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},7).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC08_Add_Survey/Screenshot/${testcaseData}.png

             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'     ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Error' or '${Status}' == 'FAIL'       ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},7).value}"     -

             Write Excel Cell        ${i}    8       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    9       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    10       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    11       value=${Suggestion}        sheet_name=TestData
    END
    Save Excel Document       Result/WriteExcel/TC08_Add_Survey_result.xlsx
    Close All Excel Documents
    CloseWebBrowser
    Stop Video Recording      alias=None

*** Keywords ***
Officer Login
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Click element  ${Login_officer}
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   user
    Input Password  ${pass_locate}   123456
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}
    Sleep  1s
    Go To    ${AddSurvey_URL}
    Set Selenium Speed      0.3s

Add Survey Page
    [Arguments]     ${Number_Survey}    ${status}    ${S_Surveyor}   ${Fritname}    ${Lastname}
    Input Text      ${number}      ${Number_Survey}
    Run keyword If   '${status}'!='${Empty}'    Select From List By Label      ${number_status}     ${status}
    Run keyword If   '${S_Surveyor}'!='${Empty}'    Select From List By Label      ${surveyor_sur}     ${S_Surveyor}
    Input Text      ${fritname_sur}      ${Fritname}
    Input Text      ${lastname_sur}      ${Lastname}
    Click Element   ${cilk_button}
    Sleep  5s

Check Error page
    [Arguments]     ${Actual_Result}
        Log To Console  ${testcaseData}
        IF  "${testcaseData}" == "TD002"
             ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${number_alert_2}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${number_alert_2}
            END
        ELSE IF  "${testcaseData}" == "TD003"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${number_alert_2}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${number_alert_2}
            END
        ELSE IF  "${testcaseData}" == "TD004"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${number_alert_2}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${number_alert_2}
            END
        ELSE IF  "${testcaseData}" == "TD005"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${number_alert_2}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${number_alert_2}
            END
        ELSE IF  "${testcaseData}" == "TD006"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${number_alert_1}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${number_alert_1}
            END
        ELSE IF  "${testcaseData}" == "TD016"
           ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${fritname_alert_2}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${fritname_alert_2}
            END
        ELSE IF  "${testcaseData}" == "TD018"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${fritname_alert_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${fritname_alert_2}
                END
        ELSE IF  "${testcaseData}" == "TD024"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${fritname_alert_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${fritname_alert_1}
                END
        ELSE IF  "${testcaseData}" == "TD026"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${lastname_alert_2}
                END
        ELSE IF  "${testcaseData}" == "TD027"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${lastname_alert_2}
                END
        ELSE IF  "${testcaseData}" == "TD034"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${lastname_alert_1}
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
        Log To Console      ${message}
        Log To Console      ${Status}
      [Return]   ${Status}  ${message}
