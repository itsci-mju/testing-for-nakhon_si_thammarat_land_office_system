*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${Questions_URL}                http://localhost:8086/TeeDin/editquestions/24
${Browser}                      chrome
${EQ_TopQuestion}               //textarea[@id='qt_topics']
${EQ_DetailQuestion}            //textarea[@id='qt_detail']
${Cilk_button}                  //input[@id='ok']