*** Settings ***
Library           SeleniumLibrary


*** Variables ***



*** Keywords ***
Abrir Site do Robot
    Open Browser  https://robotframework.org/  chrome

Fechar site
    Close Browser


*** Test Cases ***
Cenário 1: Acessando o site do Robot
    Abrir Site do Robot
    Fechar site
