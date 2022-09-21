*** Settings ***
Library        SeleniumLibrary
Library        ExcelLibrary
Library	        Collections
Library         DebugLibrary
Library          ScreenCapLibrary
Resource    ../Resources/RS_Add_News.robot
Resource    ../Resources/RS_Login.robot

*** Test Cases ***
TC12_Add_News
    Officer Login
    Start Video Recording   alias=None  name=TC12_Add_News  fps=None    size_percentage=1   embed=True  embed_width=100px   monitor=1
    Open Excel Document     TestData//TC12_Add_News.xlsx     doc_id=TestData
    ${eclin}    Get Sheet   TestData
    #Debug
     FOR    ${i}    IN RANGE   2    ${eclin.max_row+1}
            ${tcid}     Set Variable if    '${eclin.cell(${i},1).value}'=='None'    ${Empty}     ${eclin.cell(${i},1).value}
             Set Suite Variable  ${testcaseData}  ${tcid}
             ${n_coverphoto}     Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
             Set Suite Variable  ${add_img1}  ${n_coverphoto}
             ${n_topics}     Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}
             ${n_detail}     Set Variable if    '${eclin.cell(${i},4).value}'=='None'    ${Empty}     ${eclin.cell(${i},4).value}
             ${n_image1}     Set Variable if    '${eclin.cell(${i},5).value}'=='None'    ${Empty}     ${eclin.cell(${i},5).value}
             Set Suite Variable  ${add_img2}  ${n_image1}
             ${n_image2}     Set Variable if    '${eclin.cell(${i},6).value}'=='None'    ${Empty}     ${eclin.cell(${i},6).value}
             Set Suite Variable  ${add_img3}  ${n_image2}
             ${n_image3}     Set Variable if    '${eclin.cell(${i},7).value}'=='None'    ${Empty}     ${eclin.cell(${i},7).value}
             Set Suite Variable  ${add_img4}  ${n_image3}

                IF     ${i} >= 3
                    Go To     ${AddNew_Url}
                END
             Add News Page      ${n_coverphoto}    ${n_topics}    ${n_detail}   ${n_image1}   ${n_image2}   ${n_image3}
             ${Status_1}   ${message_1}  Run Keyword If    ${i}<=${eclin.max_row}    Check Error page     ${eclin.cell(${i},8).value}

             ${Status_Actual}       Set Variable if    ${i}<=${eclin.max_row}   ${Status_1}
             ${Status}       Set Variable if    '${Status_Actual}' == 'True'      PASS            FAIL
             Run Keyword If     '${Status}' == 'FAIL'    Capture Page Screenshot    ${EXECDIR}/Result/TC12_Add_News/Screenshot/${testcaseData}.png

             ${get_message}       Set Variable if    ${i}<=${eclin.max_row}   ${message_1}
             ${message}           Set Variable if    '${message_1}' == '${text_not_alert}'      ${Empty}      ${message_1}

             ${Error}       Set Variable if    '${Status}' == 'FAIL'      Error         No Error
             ${Suggestion}       Set Variable if    '${Error}' == 'Not Found Alert' or '${Status}' == 'FAIL'      ควรมีการแจ้งเตือนให้ผู้ใช้งาน "${eclin.cell(${i},8).value}"     -


             Write Excel Cell        ${i}    9       value=${message}        sheet_name=TestData
             Write Excel Cell        ${i}    10       value=${Status}        sheet_name=TestData
             Write Excel Cell        ${i}    11       value=${Error}        sheet_name=TestData
             Write Excel Cell        ${i}    12       value=${Suggestion}        sheet_name=TestData

    END
    Save Excel Document       Result/WriteExcel/TC12_Add_News_result.xlsx
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
    Go To    ${AddNew_Url}

Add News Page
    [Arguments]     ${coverphoto}  ${topics}  ${detail}
    ...             ${image1}  ${image2}  ${image3}
    Scroll element into view    ${news_coverphoto}
    Run keyword If   '${coverphoto}'!='${Empty}'    Choose File        ${news_coverphoto}       ${coverphoto}
    ${Alert1}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert1}   Convert To String   ${Alert1}[1]
    Log To Console   ${get_Alert1}
    Set Suite Variable  ${message_image1}  ${get_Alert1}


    Scroll element into view    ${news_topics}
    Input Text        ${news_topics}    ${topics}
    Scroll element into view    ${news_detail}
    Input Text        ${news_detail}    ${detail}

    Scroll element into view    ${news_image1}
    Run keyword If   '${image1}'!='${Empty}'    Choose File        ${news_image1}        ${image1}
    ${Alert2}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert2}   Convert To String   ${Alert2}[1]
    Set Suite Variable  ${message_image2}  ${get_Alert2}


    Scroll element into view    ${news_image2}
    Run keyword If   '${image2}'!='${Empty}'    Choose File        ${news_image2}        ${image2}
    ${Alert3}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert3}   Convert To String   ${Alert3}[1]
    Set Suite Variable  ${message_image3}  ${get_Alert3}


    Scroll element into view    ${Cilk_Button}
    Run keyword If   '${image3}'!='${Empty}'    Choose File        ${news_image3}        ${image3}
    ${Alert4}    Run keyword and ignore error    Handle Alert   timeout=10s
    ${get_Alert4}   Convert To String   ${Alert4}[1]
    Set Suite Variable  ${message_image4}  ${get_Alert4}

    Click element   ${Cilk_Button}

Check Error page
    [Arguments]     ${Actual_Result}
         Log To Console  ${testcaseData}
         IF  "${testcaseData}" == "TD002"
                    ${message}     Convert To String    ${message_image1}
         ELSE IF    "${testcaseData}" == "TD004"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${photo_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${photo_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD007"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${topics_alert_2}
                     IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${topics_alert_2}
                     END
         ELSE IF    "${testcaseData}" == "TD008"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${topics_alert_2}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${topics_alert_2}
                    END
         ELSE IF    "${testcaseData}" == "TD014"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${topics_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${topics_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD017"
                     ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${detail_alert_2}
                     IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${detail_alert_2}
                     END
         ELSE IF    "${testcaseData}" == "TD018"
                     ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${detail_alert_2}
                     IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${detail_alert_2}
                     END
         ELSE IF    "${testcaseData}" == "TD024"
                     ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${detail_alert_1}
                     IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${detail_alert_1}
                     END
         ELSE IF    "${testcaseData}" == "TD026"
                    ${message}     Convert To String    ${message_image2}
         ELSE IF    "${testcaseData}" == "TD028"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${image1_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${image1_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD030"
                    ${message}     Convert To String    ${message_image3}
         ELSE IF    "${testcaseData}" == "TD032"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${image2_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${image2_alert_1}
                    END
         ELSE IF    "${testcaseData}" == "TD034"
                    ${message}     Convert To String    ${message_image4}
         ELSE IF    "${testcaseData}" == "TD036"
                    ${checkVisible}  Run Keyword And Return Status  Page Should Contain Element  ${image3_alert_1}
                    IF  '${checkVisible}' == 'True'
                        ${message}  Get Text  ${image3_alert_1}
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

        Log To Console      ${message}
        Log To Console      ${Status}
      [Return]   ${Status}  ${message}