*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library          ScreenCapLibrary
Resource    ../Resources/RS_Remove_File.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC16_Remove_File
    Officer Login
    Start Video Recording   alias=None  name=TC16_Remove_File  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC16_Remove_File.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData

     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}

             IF     ${i} == 2
                 Remove File Page
             ELSE
                Cancel File
             END
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},3).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL


             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC16_Remove_File/Screenshot/${testcaseData}.png


             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      -       ${message_1}

             ${Error}       Set Variable if    '${get_message}' == '${text_not_alert}'      Not Found Alert         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},3).value}"     -


             Write Excel Cell        ${i}    4       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    5       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    6       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC16_Remove_File_result.xlsx
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
    Sleep  5s
    Go to    ${RemoveNews_URL}
    Set Selenium Speed      0.3s

Remove File Page
    Click element   ${Cilk_Remove}
    Run keyword and ignore error  Handle Alert  action=ACCEPT
    ${Alert1}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert1}   Convert To String   ${Alert1}[1]
    Log To Console   ${get_Alert1}
    Set Suite Variable  ${message_remove}  ${get_Alert1}
    Run keyword and ignore error  Handle Alert  action=ACCEPT

Cancel File
    Click element   ${Cilk_Remove}
    Run keyword and ignore error  Handle Alert  action=DISMISS

Check Error page
    [Arguments]     ${Actual_Result}
         Log To Console  ${testcaseData}
         IF  "${testcaseData}" == "TD001"
              ${message}     Convert To String    ${message_remove}
         ELSE IF  "${testcaseData}" == "TD002"
              ${message}    Check Page   ${Page_Remove}
         END

        IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
        END

        Log To Console      ${message}
        Log To Console      ${Status}
      [Return]   ${Status}  ${message}

Check Page
    [Arguments]  ${locator}
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${locator}     30s
    ${Result}  Set Variable if    '${Status}'=='True'      เอกสารไม่ถูกลบ      ไม่ได้อยู่หน้ารายการประกาศสำคัญ
    [Return]     ${Result}