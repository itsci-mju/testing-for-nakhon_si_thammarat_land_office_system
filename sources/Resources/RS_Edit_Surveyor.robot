*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${ED_Surveyor_Url}         http://localhost:8086/TeeDin/editsurveyor/109
${surveyor_firstname}       //input[@id='surveyor_firstname']
${surveyor_lastname}        //input[@id='surveyor_lastname']
${Office}                   //select[@name='OfficeBean.office_id']
${surveyor_phone}           //input[@id='surveyor_phone']
${ED_Status}                   //select[@id='surveyor_status']
${Cilck_Button}              //input[@id='ok']
${text_not_alert}           Alert not found in 5 seconds.
${firstname_alert_1}        (//*[@data-bv-validator='notEmpty'])[1]
${firstname_alert_2}        (//*[@data-bv-validator='regexp'])[1]
${lastname_alert_1}         (//*[@data-bv-validator='notEmpty'])[2]
${lastname_alert_2}         (//*[@data-bv-validator='regexp'])[2]
${phone_alert_1}            (//*[@data-bv-validator='notEmpty'])[4]
${phone_alert_2}            (//*[@data-bv-validator='regexp'])[4]
