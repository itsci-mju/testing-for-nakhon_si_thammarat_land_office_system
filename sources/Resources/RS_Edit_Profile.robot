*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Register_URL}         http://localhost:8086/TeeDin/editprofile
${Browser}              chrome
${EP_FristName}         //input[@id='firstname']
${EP_LastName}          //input[@id='lastname']
${EP_Profile}           //input[@id='m_image']
${EP_Password}          //input[@id='password']
${EP_RePassword}        //input[@id='password1']
${EP_ConPassword}       //input[@id='password2']
${EP_Cilkbutton}        //input[@id='ok']
${message}              (//*[@data-bv-validator='notEmpty'])[1]
