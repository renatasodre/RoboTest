*** Settings ***
Library           SeleniumLibrary


*** Variables ***
${URL}    https://demo.automationtesting.in/Register.html
${BROWSER}    chrome
${input_nome}    xpath=//input[@type='text' and @placeholder='First Name' and @ng-model='FirstName']
${input_apelido}    xpath=//input[@type='text' and @placeholder='Last Name' and @ng-model='LastName']
${textarea_endereco}    xpath=//textarea[@ng-model='Adress']
${input_email}    xpath=//input[@type='email' and @ng-model='EmailAdress'] 
${input_telefone}    xpath=//input[@type='tel' and @ng-model='Phone']
${GENERO_MASCULINO}     Male
${GENERO_FEMININO}      FeMALE
${LABEL_HOBBIES}    xpath://label[@type='checkbox' and contains(text(), 'Hobbies')]
${CHECKBOX_HOBBIES}    ${LABEL_HOBBIES}/parent::div//input[@type='checkbox']
${div_idioma}    id:msdd
${select_skills}    id:Skills
${country}    id:countries
${select_pais}    css=.select2-selection--single
${ano}    id:yearbox
${mes}    xpath=//select[@ng-model='monthbox']
${dia}    id:daybox
${input_senha}    id:firstpassword
${input_confirmacao_senha}    id:secondpassword
${CAMINHO_FOTO}    "C:\Users\renat\projects\robotselenium\Resources\logan-weaver-lgnwvr-ezcWbV3Pf_c-unsplash.jpg"
${input_foto}    id:imagesrc 
${Button_submit}    submitbtn


*** Keywords ***
Configurar Opções do Navegador
    # Configura opções do Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    
    # Adiciona argumentos
    Call Method    ${options}    add_argument    --disable-extensions       # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups 
    Call Method    ${options}    add_argument    --disable-notifications     # Desabilita notificações   
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance
    
    RETURN    ${options}

Abrir site ADS
    # Abre o navegador na página de home
    ${chrome_options}    Configurar Opções do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Fechar Pop-up de Cookies
    Wait Until Page Contains Element    xpath=//p[contains(@class, 'fc-button-label') and contains(text(), 'Do not consent')]    timeout=10s
    Click Element    xpath=//p[contains(@class, 'fc-button-label') and contains(text(), 'Do not consent')]

Preencher campos
    Input Text    ${input_nome}    Renata
    Input Text    ${input_apelido}    Sodré
    Input Text    ${textarea_endereco}    Rua Beato Francisco Pacheco 23, Cabrão, Viana do Castelo, 4990-730.
    Input Text    ${input_email}    rribeirosodre@gmail.com
    Input Text    ${input_telefone}    9999999999
    Input Text    ${input_senha}    eiAbA!#ZYxZ4$U
    Input Text    ${input_confirmacao_senha}    eiAbA!#ZYxZ4$U


Selecionar gênero
    [Arguments]    ${genero}
    
    @{localizadores}    Create List
    ...    xpath://label[contains(@for, 'gender-radio') and text()='${genero}']
    ...    xpath://input[@name='radiooptions' and @value='${genero}']
    
    ${elemento_encontrado}    Set Variable    ${FALSE}
    
    FOR    ${localizador}    IN    @{localizadores}
        ${status}    ${result}    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${localizador}    timeout=10s
        Run Keyword If    '${status}' == 'PASS'    Run Keywords
        ...    Scroll Element Into View    ${localizador}
        ...    AND    Click Element    ${localizador}
        ...    AND    Set Local Variable    ${elemento_encontrado}    ${TRUE}
        ...    AND    Exit For Loop
    END


Selecionar Hobbies
    [Arguments]    ${hobby}
    Click Element    xpath=//input[@type='checkbox' and @value='${hobby}']

   
Selecionar Idioma
    [Arguments]    ${idioma}
    
    # Abre o dropdown de idiomas
    Click Element    ${div_idioma}
    
    # Seleciona o idioma desejado
    Click Element    xpath=//a[contains(text(),'${idioma}')]
    
    # Verifica se o idioma foi selecionado corretamente
    Run Keyword If    not Element Should Contain    ${select_skills}    ${idioma}    Fail    O idioma '${idioma}' não foi selecionado corretamente


Selecionar País
    [Arguments]    ${pais}
    
    # Abre o dropdown de países
    Click Element    ${select_pais}
    
    # Seleciona o país desejado
    Select From List By Label    ${select_pais}    ${pais}
    
    # Verifica se o país foi selecionado corretamente
    Run Keyword If    not Element Should Contain    ${select_pais}    ${pais}    Fail    O país '${pais}' não foi selecionado corretamente


Selecionar country
    [Arguments]    ${outropais}
    
    # Abre o dropdown de países
    Click Element    ${country}
    
    # Seleciona o país desejado
    Select From List By Label    ${country}    ${outropais}
    
    # Verifica se o país foi selecionado corretamente
    Run Keyword If    not Element Should Contain    ${country}    ${outropais}    Fail    O país '${outropais}' não foi selecionado corretamente



Selecionar Skills
    [Arguments]    ${skill}
    
    # Abre o dropdown de skills
    Click Element    ${select_skills}
    
    # Seleciona a skill desejada
    Select From List By Label    ${select_skills}    ${skill}
    
    # Verifica se a skill foi selecionada corretamente
    Run Keyword If    not Element Should Contain    ${select_skills}    ${skill}    Fail    A skill '${skill}' não foi selecionada corretamente



Preencher Ano de Nascimento
    [Arguments]    ${ano}=1993
    Clear Element Text    id:yearbox
    Input Text    id:yearbox    ${ano}
    Press Keys    id:yearbox    ENTER


Preencher Mês de Nascimento
    [Arguments]    ${mes}=March
    Clear Element Text    xpath=//select[@ng-model='monthbox']
    Input Text    xpath=//select[@ng-model='monthbox']    ${mes}
    Press Keys    xpath=//select[@ng-model='monthbox']    ENTER


Preencher Dia de Nascimento
    [Arguments]    ${dia}=15
    Clear Element Text    id:daybox
    Input Text    id:daybox    ${dia}
    Press Keys    id:daybox    ENTER


Selecionar Foto
    [Arguments]    ${caminho_foto}=${CAMINHO_FOTO}
    
    # Verifica a existência do arquivo
    ${arquivo_existe}    Evaluate    os.path.exists('${caminho_foto}')    modules=os
    Run Keyword Unless    ${arquivo_existe}    Fail    Arquivo de foto não encontrado: ${caminho_foto}
    
    # Tenta múltiplas estratégias de upload
    Run Keyword And Ignore Error    Choose File    ${input_foto}    ${caminho_foto}
    Run Keyword And Ignore Error    Upload Foto Por JavaScript    ${caminho_foto}

    
Clicar em submit
    Click Element    ${Button_submit} 

Fechar site
    Close Browser


*** Test Cases ***
Cenário 1: Preencher Formulário ADS
    Abrir site ADS
    Fechar Pop-up de Cookies
    Preencher campos
    Selecionar gênero    ${GENERO_FEMININO}
    Selecionar Hobbies    Movies
    Selecionar Idioma    Italian
    Selecionar Skills    Python
    Selecionar country    Select Country
    Selecionar País    Japan
    Preencher Ano de Nascimento
    Preencher Mês de Nascimento
    Preencher Dia de Nascimento
    Carregar Foto    ${CAMINHO_FOTO}
    Clicar em submit
    Fechar site