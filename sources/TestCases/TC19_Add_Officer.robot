*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library          ScreenCapLibrary
Resource    ../Resources/RS_Add_Officer.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC19_Add_Officer
    Admin Login
    Start Video Recording   alias=None  name=TC19_Add_Officer  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC19_Add_Officer.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${firstname}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${lastname}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
             ${idcard}     Set Variable if    '${eclin.cell(${i},4).value}'=='None'    ${Empty}     ${eclin.cell(${i},4).value}
             ${o_position}     Set Variable if    '${eclin.cell(${i},5).value}'=='None'    ${Empty}     ${eclin.cell(${i},5).value}
             ${o_office}     Set Variable if    '${eclin.cell(${i},6).value}'=='None'    ${Empty}     ${eclin.cell(${i},6).value}
             ${username}     Set Variable if    '${eclin.cell(${i},7).value}'=='None'    ${Empty}     ${eclin.cell(${i},7).value}
             ${password}     Set Variable if    '${eclin.cell(${i},8).value}'=='None'    ${Empty}     ${eclin.cell(${i},8).value}
             Set Suite Variable  ${passdata}  ${password}
             ${repassword}      Set Variable if    '${eclin.cell(${i},9).value}'=='None'    ${Empty}     ${eclin.cell(${i},9).value}

                IF     ${i} >= 3
                    sleep   3s
                    Go To     ${AddOfficer_Url}
                END

             Add Officer Page    ${firstname}   ${lastname}  ${idcard}  ${o_position}  ${o_office}
             ...                   ${username}  ${password}  ${repassword}

             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},10).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL


             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC19_Add_Officer/Screenshot/${testcaseData}.png


             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'       ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},10).value}"     -


             Write Excel Cell        ${i}    11       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    12    value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    13      value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    14       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC19_Add_Officer_result.xlsx
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
    Go To    ${AddOfficer_Url}
    Set Selenium Speed      0.3s

Add Officer Page
    [Arguments]     ${firstname_off}  ${lastname_off}  ${idcard_officer}   ${position_officer}   ${Office_name_officer}
    ...             ${username_off}  ${password_off}  ${repassword_off}
    Input Text      ${firstname}    ${firstname_off}
    Input Text      ${lastname}     ${lastname_off}
    Input Text      ${idcard}   ${idcard_officer}
    Run keyword If   '${position_officer}'!='${Empty}'      Select From List By Label      ${position}       ${position_officer}
    Run keyword If   '${Office_name_officer}'!='${Empty}'      Select From List By Label      ${office_name}       ${Office_name_officer}
    Input Text      ${username}     ${username_off}
    Input Text      ${password}     ${password_off}
    Input Text      ${repassword}   ${repassword_off}
    Click element    ${Cilck_Button}

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
         ELSE IF    "${testcaseData}" == "TD023"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD025"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD026"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD028"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${idcard_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${idcard_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD041"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${username_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${username_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD043"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${username_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${username_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD046"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${username_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${username_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD048"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${username_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${username_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD049"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${username_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${username_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD050"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${username_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${username_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD052"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${password_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${password_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD053"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${password_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${password_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD054"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${password_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${password_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD060"
               ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${password_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${password_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD062"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${repassword_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${repassword_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD063"
              ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${repassword_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${repassword_alert_1}
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
