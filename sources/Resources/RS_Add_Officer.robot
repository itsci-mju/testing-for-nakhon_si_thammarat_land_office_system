*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${AddOfficer_Url}         http://localhost:8086/TeeDin/addofficer
${firstname}            //input[@id='firstname']
${lastname}             //input[@id='lastname']
${idcard}              //input[@id='idcard']
${position}            //select[@id='of_position']
${office_name}         //select[@id='office_id']
${username}             //input[@id='username']
${password}             //input[@id='password']
${repassword}            //input[@id='repassword']
${Cilck_Button}           //input[@id='ok']
${text_not_alert}            Alert not found in 20 seconds.
${firstname_alert_1}         (//*[@data-bv-validator='notEmpty'])[1]
${firstname_alert_2}         (//*[@data-bv-validator='regexp'])[1]
${lastname_alert_1}          (//*[@data-bv-validator='notEmpty'])[2]
${lastname_alert_2}           (//*[@data-bv-validator='regexp'])[2]
${idcard_alert_1}             (//*[@data-bv-validator='notEmpty'])[3]
${idcard_alert_2}               (//*[@data-bv-validator='regexp'])[3]
${username_alert_1}           (//*[@data-bv-validator='notEmpty'])[4]
${username_alert_2}             (//*[@data-bv-validator='regexp'])[4]
${password_alert_1}             (//*[@data-bv-validator='notEmpty'])[5]
${password_alert_2}             (//*[@data-bv-validator='stringLength'])[1]
${repassword_alert_1}           (//*[@data-bv-validator='notEmpty'])[6]
${repassword_alert_2}           (//*[@data-bv-validator='identical'])[1]
