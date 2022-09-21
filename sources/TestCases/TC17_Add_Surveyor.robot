*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library         DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Add_Surveyor.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC17_Add_Surveyor
    Admin Login
    Start Video Recording   alias=None  name=TC17_Add_Surveyor  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC17_Add_Surveyor.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${firstname}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${lastname}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
             ${idcard}     Set Variable if    '${eclin.cell(${i},4).value}'=='None'    ${Empty}     ${eclin.cell(${i},4).value}
             ${a_office}     Set Variable if    '${eclin.cell(${i},5).value}'=='None'    ${Empty}     ${eclin.cell(${i},5).value}
             ${phone}     Set Variable if    '${eclin.cell(${i},6).value}'=='None'    ${Empty}     ${eclin.cell(${i},6).value}

                IF     ${i} >= 3
                    sleep   3s
                    Go To     ${AddSurveyor_Url}
                END

             Add Surveyor Page      ${firstname}  ${lastname}  ${idcard}   ${a_office}  ${phone}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},7).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL


             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC17_Add_Surveyor/Screenshot/${testcaseData}.png


             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},7).value}"     -


             Write Excel Cell        ${i}    8       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    9       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    10       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    11       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC17_Add_Surveyor_result.xlsx
    Close All Excel Documents
    CloseWebBrowser
    Stop Video Recording      alias=None

*** Keywords ***
Admin Login
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Click element  ${Login_officer}
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   admin
    Input Password  ${pass_locate}   111111
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}
    Sleep  1s
    Go To    ${AddSurveyor_Url}
    Set Selenium Speed      0.3s

Add Surveyor Page
    [Arguments]     ${firstname}  ${lastname}  ${idcard}   ${Office_name}  ${phone}
    Input Text      ${surveyor_firstname}   ${firstname}
    Input Text      ${surveyor_lastname}   ${lastname}
    Input Text      ${surveyor_idcard}   ${idcard}
    Run keyword If   '${Office_name}'!='${Empty}'      Select From List By Label      ${Office}       ${Office_name}
    Input Text      ${surveyor_phone}    ${phone}
    Click element   ${Cilck_Button}

Check Error page
    [Arguments]     ${Actual_Result}
         Log To Console  ${testcaseData}
         IF  "${testcaseData}" == "TD002"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${firstname_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${firstname_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD004"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${firstname_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${firstname_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD010"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${firstname_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${firstname_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD012"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${lastname_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD013"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${lastname_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD020"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${lastname_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${lastname_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD022"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD024"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD025"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD027"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD032"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${phone_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${phone_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD034"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${phone_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${phone_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD035"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${phone_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${phone_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD036"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${phone_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${phone_alert_1}
                    END
         ELSE
              ${get_message}   Run keyword and ignore error    Handle Alert    timeout=20s
              ${message}     Convert To String   ${get_message}[1]
         END

        IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
        END

        Log To Console      ${message}
        Log To Console      ${Status}
      [Return]   ${Status}  ${message}