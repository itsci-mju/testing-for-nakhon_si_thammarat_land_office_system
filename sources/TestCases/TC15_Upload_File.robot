*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library         DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Upload_File.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC15_Upload_File
    Officer Login
    Start Video Recording   alias=None  name=TC15_Upload_File  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC15_Upload_File.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${file_image}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             Set Suite Variable  ${add_img1}  ${file_image}
             ${file_Detail}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
             ${file_url}     Set Variable if    '${eclin.cell(${i},4).value}'=='None'    ${Empty}     ${eclin.cell(${i},4).value}
             Set Suite Variable  ${add_img2}  ${file_url}

                IF     ${i} >= 3
                    sleep   5s
                    Go To     ${UploadFile_Url}
                END
             Upload File Page       ${file_image}   ${file_Detail}  ${file_url}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},5).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL

             Run keyword and ignore error    Handle Alert   timeout=20s
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC15_Upload_File/Screenshot/${testcaseData}.png


             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}       ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'       ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},5).value}"     -


             Write Excel Cell        ${i}    6       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    7       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    8       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    9       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC15_Upload_File_result.xlsx
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
    Go To    ${UploadFile_Url}

Upload File Page
    [Arguments]     ${image}   ${Detail}  ${file}
    Run keyword If   '${image}'!='${Empty}'    Choose File        ${file_image}       ${image}
    ${Alert1}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert1}   Convert To String   ${Alert1}[1]
    Log To Console   ${get_Alert1}
    Set Suite Variable  ${message_image1}  ${get_Alert1}


    Input Text        ${file_Detail}    ${Detail}

    Run keyword If   '${file}'!='${Empty}'    Choose File        ${file_url}         ${file}
    ${Alert2}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert2}   Convert To String   ${Alert2}[1]
    Log To Console   ${get_Alert2}
    Set Suite Variable  ${message_image2}  ${get_Alert2}

    Click element   ${Cilck_Button}

Check Error page
    [Arguments]     ${Actual_Result}
         Log To Console  ${testcaseData}
         IF    "${testcaseData}" == "TD002"
              ${message}     Convert To String    ${message_image1}
              Run keyword and ignore error  Alert Should Be Present    action=ACCEPT
         ELSE IF    "${testcaseData}" == "TD007"
               ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${Detail_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${Detail_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD008"
               ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${Detail_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${Detail_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD009"
               ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${Detail_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${Detail_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD014"
               ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${Detail_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${Detail_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD016"
               ${message}     Convert To String    ${message_image2}
               Run keyword and ignore error  Alert Should Be Present    action=ACCEPT
         ELSE IF    "${testcaseData}" == "TD018"
               ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${file_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${file_alert_1}
                    END
         ELSE
            ${get_message}   Run keyword and ignore error    Handle Alert    timeout=20s
            ${message}     Convert To String   ${get_message}[1]
            Run keyword and ignore error  Alert Should Be Present    action=ACCEPT
         END

        IF  '${Actual_Result.strip()}' == '${message.strip()}'
            Set Suite Variable  ${Status}  True
        ELSE
            Set Suite Variable  ${Status}  False
        END

        Log To Console      ${message}
        Log To Console      ${Status}
      [Return]   ${Status}  ${message}