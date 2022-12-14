*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	       Collections
Library        ScreenCapLibrary
Resource    ../Resources/RS_Update_Survey.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC09_Update_Survey
    Officer Login
    Start Video Recording   alias=None  name=TC09_Update_Survey  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC09_Update_Survey.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${Status_Number}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${Fritname}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
             ${Lastname}     Set Variable if    '${eclin.cell(${i},4).value}'=='None'    ${Empty}     ${eclin.cell(${i},4).value}
                IF     ${i} >= 3
                    Go To     ${Edit_survey}
                END
             Edit Survey Page      ${Status_Number}     ${Fritname}    ${Lastname}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},5).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC09_Update_Survey/Screenshot/${testcaseData}.png

             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'     ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Error' or '${Status}' == 'FAIL'       ??????????????????????????????????????????????????????????????????????????????????????? "${eclin.cell(${i},5).value}"     -

             Write Excel Cell        ${i}    6       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    9       value=${Suggestion}        sheet_name=TestData
    END
    Save Excel Document       Result/WriteExcel/TC09_Update_Survey_result.xlsx
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
    Go To    ${Edit_survey}
    Set Selenium Speed      0.3s

Edit Survey Page
    [Arguments]       ${status}    ${Fritname}    ${Lastname}
    Run keyword If   '${status}'!='${Empty}'    Select From List By Label      ${number_status}     ${status}
    Input Text      ${fritname_sur}      ${Fritname}
    Input Text      ${lastname_sur}      ${Lastname}
    Click Element    ${cilk_button}
    Sleep  5s

Check Error page
     [Arguments]     ${Actual_Result}
        Log To Console  ${testcaseData}

        IF  "${testcaseData}" == "TD009"
           ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${fritname_alert_2}
            IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${fritname_alert_2}
            END
        ELSE IF  "${testcaseData}" == "TD011"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${fritname_alert_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${fritname_alert_2}
                END
        ELSE IF  "${testcaseData}" == "TD017"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${fritname_alert_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${fritname_alert_1}
                END
        ELSE IF  "${testcaseData}" == "TD019"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${lastname_alert_2}
                END
        ELSE IF  "${testcaseData}" == "TD020"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${lastname_alert_2}
                END
        ELSE IF  "${testcaseData}" == "TD027"
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
