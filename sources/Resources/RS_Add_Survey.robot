*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${AddSurvey_URL}          http://localhost:8086/TeeDin/addsurvey?survey_land=%E0%B8%A3%E0%B8%B1%E0%B8%87%E0%B8%A7%E0%B8%B1%E0%B8%94%E0%B8%AD%E0%B8%AD%E0%B8%81%E0%B9%82%E0%B8%89%E0%B8%99%E0%B8%94%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%94%E0%B8%B4%E0%B8%99%E0%B9%80%E0%B8%89%E0%B8%9E%E0%B8%B2%E0%B8%B0%E0%B8%A3%E0%B8%B2%E0%B8%A2
${AddSurvey}              //div[contains(text(),'รังวัดออกโฉนดที่ดินเฉพาะราย')]
${number}                 //input[@id='survey_number']
${number_status}          //select[@id='survey_status']
${surveyor_sur}           //select[@id='surveyor_id']
${fritname_sur}           //input[@id='survey_firstname']
${lastname_sur}           //input[@id='survey_lastname']
${cilk_button}            //input[@id='ok']
${text_not_alert}         Alert not found in 5 seconds.
${number_alert_1}         (//*[@data-bv-validator='notEmpty'])[1]
${number_alert_2}         (//*[@data-bv-validator='regexp'])[1]
${fritname_alert_1}       (//*[@data-bv-validator='notEmpty'])[2]
${fritname_alert_2}       (//*[@data-bv-validator='regexp'])[2]
${lastname_alert_1}       (//*[@data-bv-validator='notEmpty'])[3]
${lastname_alert_2}       (//*[@data-bv-validator='regexp'])[3]