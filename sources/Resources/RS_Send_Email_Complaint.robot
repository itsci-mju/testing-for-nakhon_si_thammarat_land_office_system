*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Email_URL}                http://localhost:8086/TeeDin/sendemail
${Office}                   //select[@id='office_id']
${emailMessage}             //textarea[@id='emailMessage']
${Cilk_button}              //button[@id='ok']
${SendEmail}                //a[contains(text(),'ร้องเรียน')]
${text_error}               //a[contains(text(),'หน้าหลัก')]
${text_not_alert}           Alert not found in 5 seconds.