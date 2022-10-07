*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library        ScreenCapLibrary
Resource    ../Resources/RS_Edit_Profile.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC04_Edit_Profile
    Customer Login
    Start Video Recording   alias=None  name=TC04_Edit_Profile  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC04_Edit_Profile.xlsx     doc_id=TestData
    ${excel}    Get Sheet   TestData
    FOR    ${i}    IN RANGE   2    ${excel.max_row+1}
            ${tcid}     Set Variable if    '${excel.cell(${i},1).value}'=='None'    ${Empty}     ${excel.cell(${i},1).value}
             Set Suite Variable  ${testcase}  ${tcid}
            ${Fristname}     Set Variable if    '${excel.cell(${i},2).value}'=='None'    ${Empty}     ${excel.cell(${i},2).value}
            ${Lastname}     Set Variable if    '${excel.cell(${i},3).value}'=='None'    ${Empty}     ${excel.cell(${i},3).value}
            ${PROFILE}     Set Variable if    '${excel.cell(${i},4).value}'=='None'    ${Empty}     ${excel.cell(${i},4).value}
            ${Password}     Set Variable if    '${excel.cell(${i},5).value}'=='None'    ${Empty}     ${excel.cell(${i},5).value}
            ${New_Password}     Set Variable if    '${excel.cell(${i},6).value}'=='None'    ${Empty}     ${excel.cell(${i},6).value}
            ${con_New_Password}     Set Variable if    '${excel.cell(${i},7).value}'=='None'    ${Empty}     ${excel.cell(${i},7).value}

             IF     ${i} >= 3
                 Go To      ${ED_Register_URL}
             END
             Edit Profile Page   ${Fristname}   ${Lastname}  ${PROFILE}   ${Password}  ${New_Password}  ${con_New_Password}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${excel.max_row}    Check Error page     ${excel.cell(${i},8).value}
             Log To Console    ${Status_1}
             Log To Console    ${message_1}
             ${Status_Actual}       Set Variable if    ${i}<=${excel.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC04_Edit_Profile/Screenshot/${testcase}.png

             ${get_message}       Set Variable if    ${i}<=${excel.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${message}' == 'None' or '${Status}' == 'FAIL'     ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${excel.cell(${i},8).value}"     -

             Write Excel Cell        ${i}    9       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    10      value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    11       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    12       value=${Suggestion}        sheet_name=TestData
    END
    Save Excel Document       Result/WriteExcel/TC04_Edit_Profile_result.xlsx
    Close All Excel Documents
    Close Browser
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
    Go To    ${ED_Register_URL}
    Set Selenium Speed      1s

Edit Profile Page
    [Arguments]     ${FristName}   ${LastName}    ${Profile}    ${Password}      ${RePassword}    ${ConPassword}
    Input Text      ${EP_FristName}     ${FristName}
    Input Text      ${EP_LastName}      ${LastName}
    Run keyword If   '${Profile}'!='${Empty}'    Choose File        id=m_image       ${Profile}
    IF  "${testcase}" == "TD022"
        ${get_message}   Run keyword and ignore error    Handle Alert    timeout=10s
        ${message2}     Convert To String    ${get_message}[1]
        Set Suite Variable  ${add_img}  ${message2}
    END
    Input Text      ${EP_Password}          ${Password}
    Input Text      ${EP_RePassword}        ${RePassword}
    Input Text      ${EP_ConPassword}       ${ConPassword}
    Click Element   ${EP_Cilkbutton}
    Sleep  5s

Check Error page
    [Arguments]     ${Actual_Result}
         Log To Console  ${testcase}

          IF  "${testcase}" == "TD022"
            ${message}     Convert To String    ${add_img}
            Run keyword and ignore error    Handle Alert    timeout=10s
          ELSE IF  "${testcase}" == "TD002"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_firtname_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_firtname_2}
                END
          ELSE IF  "${testcase}" == "TD004"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_firtname_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_firtname_2}
                END
          ELSE IF  "${testcase}" == "TD010"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_firtname_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_firtname_1}
                END
          ELSE IF  "${testcase}" == "TD012"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_lastname_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_lastname_2}
                END
          ELSE IF  "${testcase}" == "TD013"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_lastname_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_lastname_2}
                END
          ELSE IF  "${testcase}" == "TD020"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_lastname_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_lastname_1}
                END
          ELSE IF  "${testcase}" == "TD027"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE IF  "${testcase}" == "TD029"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_password_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_password_2}
                END
          ELSE IF  "${testcase}" == "TD030"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_password_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_password_2}
                END
          ELSE IF  "${testcase}" == "TD031"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_password_2}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_password_2}
                END
          ELSE IF  "${testcase}" == "TD032"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE IF  "${testcase}" == "TD033"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE IF  "${testcase}" == "TD034"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE IF  "${testcase}" == "TD035"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE IF  "${testcase}" == "TD036"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE IF  "${testcase}" == "TD039"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${alert_repassword_1}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${alert_repassword_1}
                END
          ELSE
            ${get_message}   Run keyword and ignore error    Handle Alert    timeout=10s
            ${message}     Convert To String   ${get_message}[1]
          END
    # "---------------------------------------------------"
        IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
        END

      [Return]   ${Status}  ${message}
