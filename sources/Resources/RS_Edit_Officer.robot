*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${AddOfficer_Url}         http://localhost:8086/TeeDin/editofficer/Officer125
${firstname}            //input[@id='firstname']
${lastname}             //input[@id='lastname']
${ED_Status}            //select[@id='of_status']
${position}            //select[@id='of_position']
${office_name}         //select[@id='office_id']
${ED_password}         //input[@id='password1']
${repassword}            //input[@id='password2']
${Cilck_Button}           //input[@id='ok']
${text_not_alert}            Alert not found in 20 seconds.
${firstname_alert_1}         (//*[@data-bv-validator='notEmpty'])[1]
${firstname_alert_2}         (//*[@data-bv-validator='regexp'])[1]
${lastname_alert_1}          (//*[@data-bv-validator='notEmpty'])[2]
${lastname_alert_2}           (//*[@data-bv-validator='regexp'])[2]
${password_alert_1}             (//*[@data-bv-validator='notEmpty'])[5]
${password_alert_2}             (//*[@data-bv-validator='stringLength'])[1]
${repassword_alert_1}           (//*[@data-bv-validator='notEmpty'])[6]
${repassword_alert_2}           (//*[@data-bv-validator='identical'])[1]