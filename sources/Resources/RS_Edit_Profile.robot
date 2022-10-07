*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${ED_Register_URL}         http://localhost:8086/TeeDin/editprofile
${Browser}              chrome
${EP_FristName}         //input[@id='firstname']
${EP_LastName}          //input[@id='lastname']
${EP_Profile}           //input[@id='m_image']
${EP_Password}          //input[@id='password']
${EP_RePassword}        //input[@id='password1']
${EP_ConPassword}       //input[@id='password2']
${EP_Cilkbutton}        //input[@id='ok']
${alert_firtname_1}     (//*[@data-bv-validator='notEmpty'])[1]
${alert_firtname_2}     (//*[@data-bv-validator='regexp'])[1]
${alert_lastname_1}     (//*[@data-bv-validator='notEmpty'])[2]
${alert_lastname_2}     (//*[@data-bv-validator='regexp'])[2]
${alert_password_1}     (//*[@data-bv-validator='notEmpty'])[4]
${alert_password_2}     (//*[@data-bv-validator='stringLength'])[2]
${alert_repassword_1}      (//*[@data-bv-validator='identical'])[1]
${text_page}                    //label[@for='tab-1']
${text_not_alert}         Alert not found in 10 seconds.
