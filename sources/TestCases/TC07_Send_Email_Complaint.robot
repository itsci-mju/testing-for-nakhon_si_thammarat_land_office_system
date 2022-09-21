*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library         DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Send_Email_Complaint.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC07_Send_Email_Complaint
    Customer Login
    Start Video Recording   alias=None  name=TC07_Send_Email_Complaint  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC07_Send_Email_Complaint.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
             ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${s_Office}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             ${s_emailMessage}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
                IF     ${i} >= 3
                    Go To    ${Email_URL}
                 END
             Send Email Complaint Page      ${s_Office}    ${s_emailMessage}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},4).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC07_Send_Email_Complaint/Screenshot/${testcaseData}.png

             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'     ${Empty}        ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},4).value}"     -


             Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC07_Send_Email_Complaint_result.xlsx
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
    Go To    ${Email_URL}

Send Email Complaint Page
    [Arguments]     ${s_Office}    ${s_emailMessage}
    Run keyword If   '${s_Office}'!='${Empty}'     Select From List By Label      ${Office}     ${s_Office}
    Input Text      ${emailMessage}      ${s_emailMessage}
    Click Element   ${Cilk_button}
    Sleep  5s

Check Error page
    [Arguments]     ${ActualResult}
    Log To Console  ${testcaseData}
      IF  "${testcaseData}" == "TD001"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD002"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD003"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD004"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD007"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD008"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD009"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD010"
          ${message}  Check Home Page   ${text_error}
      ELSE IF   "${testcaseData}" == "TD011"
          ${message}  Check Home Page   ${text_error}
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

Check Home Page
    [Arguments]  ${locator}
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${locator}     30s
    ${Result}  Set Variable if    '${Status}'=='True'      ส่งเรื่องร้องเรียนสำเร็จ        ส่งเรื่องร้องเรียนไม่สำเร็จ
    [Return]     ${Result}