*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library          DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Login.robot
Resource    ../Resources/RS_Search_Survey.robot

*** Test Cases ***
TC01_Search_Survey
    Login Customer
    Start Video Recording   alias=None  name=TC01_Search_Survey  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC01_Search_Survey.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
             ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${office}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${number}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}

             IF     ${i} >= 3
                 Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
             END

             Search Survey Page      ${office}     ${number}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},4).value}


             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC01_Search_Survey/Screenshot/${testcaseData}.png


             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'       Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'     ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},4).value}"     -


             Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC01_Search_Survey_result.xlsx
    Close All Excel Documents
    CloseWebBrowser
    Stop Video Recording      alias=None

*** Keywords ***
Login Customer
    Open Browser  ${Login URl}  ${BROWSER}
    maximize browser window
    Wait Until Element Is Visible   ${user_locate}   30s
    Input Text  ${user_locate}   leena
    Input Password  ${pass_locate}   123456
    Wait Until Element Is Visible  ${btn_login}  30s
    Click Button  ${btn_login}
    Sleep  1s
    Go To    ${Search_URL}
    Set Selenium Speed      0.3s

Search Survey Page
    [Arguments]     ${office}     ${number}
    Run keyword If   '${office}'!='${Empty}'    Select From List By Label      ${Select_office}  ${office}
    Input Text      ${Survey_number}    ${number}
    Click Element   ${Cilck_Search}
    Sleep  3s

Check Error page
    [Arguments]     ${Actual_Result}
        Log To Console  ${testcaseData}
        IF  "${testcaseData}" == "TD001"
            ${message}  Check Page Search   ${text_page_search}
        ELSE IF     "${testcaseData}" == "TD002"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${text_message}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${text_message}
                END
        ELSE IF     "${testcaseData}" == "TD003"
            ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${text_message}
                IF  '${checkVisible}' == 'True'
                ${message}  Get Text  ${text_message}
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

      [Return]   ${Status}  ${message}

Check Page Search
    [Arguments]  ${locator}
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${locator}     30s
    ${Result}  Set Variable if    '${Status}'=='True'      ค้นหางานรังวัดสำเร็จ            ค้นหางานรังวัดไม่สำเร็จ
    [Return]     ${Result}



