*** Settings ***
Library        SeleniumLibrary

*** Variables ***
${Edit_survey}            http://localhost:8086/TeeDin/editsurvey?survey_number=2/3333
${number}                 //input[@id='survey_number']
${number_status}          //select[@id='survey_status']
${fritname_sur}           //input[@id='survey_firstname']
${lastname_sur}           //input[@id='survey_lastname']
${cilk_button}            //input[@id='ok']
${text_not_alert}         Alert not found in 5 seconds.
${fritname_alert_1}       (//*[@data-bv-validator='notEmpty'])[2]
${fritname_alert_2}       (//*[@data-bv-validator='regexp'])[2]
${lastname_alert_1}       (//*[@data-bv-validator='notEmpty'])[3]
${lastname_alert_2}       (//*[@data-bv-validator='regexp'])[3]