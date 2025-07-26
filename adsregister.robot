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
${GENERO_FEMININO}      FeMale
${LABEL_HOBBIES}    xpath://label[@type='checkbox' and contains(text(), 'Hobbies')]
${CHECKBOX_HOBBIES}    ${LABEL_HOBBIES}/parent::div//input[@type='checkbox']
${div_idioma}    id:msdd
${select_skills}    id:Skills
${country}    id:countries
${select_pais}    xpath=//span[contains(@class, 'select2-selection--single')]
${ano}    id:yearbox
${mes}    xpath=//select[@ng-model='monthbox']
${dia}    id:daybox
${input_senha}    id:firstpassword
${input_confirmacao_senha}    id:secondpassword
${CAMINHO_FOTO}    C:/Users/renat/projects/robotselenium/Resources/logan-weaver-lgnwvr-ezcWbV3Pf_c-unsplash.jpg
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
    Click Element    xpath=//input[@name='radiooptions' and @value='${genero}']


Selecionar Hobbies
    [Arguments]    ${hobby}
    Click Element    xpath=//input[@type='checkbox' and @value='${hobby}']


Selecionar Idioma
    [Arguments]    ${idioma}
    Click Element    ${div_idioma}
    Wait Until Element Is Visible    xpath=//a[text()='${idioma}']    timeout=10s
    Scroll Element Into View    xpath=//a[text()='${idioma}']
    Click Element    xpath=//a[text()='${idioma}']
    Click Element    xpath=//header[@id='header']
    Sleep    1s


*** Keywords ***
Selecionar País
    [Arguments]    ${pais}
    Wait Until Element Is Visible    xpath=//span[contains(@class, 'select2-selection--single')]    timeout=10s
    Click Element    xpath=//span[contains(@class, 'select2-selection--single')]
    Wait Until Element Is Visible    xpath=//input[contains(@class, 'select2-search__field')]    timeout=5s
    Input Text    xpath=//input[contains(@class, 'select2-search__field')]    ${pais}
    Press Keys    xpath=//input[contains(@class, 'select2-search__field')]    ENTER
    Element Should Contain    xpath=//span[contains(@class, 'select2-selection__rendered')]    ${pais}    O país '${pais}' não foi selecionado corretamente

Selecionar country
    [Arguments]    ${outropais}
    Click Element    ${country}
    Select From List By Label    ${country}    ${outropais}
    Sleep    1s
    Element Should Contain    ${country}    ${outropais}    Fail    O país '${outropais}' não foi selecionado corretamente

Fechar Anúncio
    Run Keyword And Ignore Error    Execute JavaScript    document.getElementById('aswift_2')?.remove();
    Sleep    0.5s

Selecionar Skills
    [Arguments]    ${skill}
    
    # Abre o dropdown de skills
    Click Element    ${select_skills}
    
    # Seleciona a skill desejada
    Select From List By Label    ${select_skills}    ${skill}
    
    # Verifica se a skill foi selecionada corretamente
    Element Should Contain    ${select_skills}    ${skill}    Fail    A skill '${skill}' não foi selecionada corretamente


Preencher Ano de Nascimento
    [Arguments]    ${ano}=1993
    Select From List By Label    id:yearbox    ${ano}

Preencher Mês de Nascimento
    [Arguments]    ${mes}=March
    Select From List By Label    xpath=//select[@ng-model='monthbox']    ${mes}

Preencher Dia de Nascimento
    [Arguments]    ${dia}=15
    Select From List By Label    id:daybox    ${dia}


Selecionar Foto
    [Arguments]    ${caminho_foto}=${CAMINHO_FOTO}
    
    # Verifica a existência do arquivo
    ${arquivo_existe}    Evaluate    os.path.exists('${caminho_foto}')    modules=os
    Run Keyword Unless    ${arquivo_existe}    Fail    Arquivo de foto não encontrado: ${caminho_foto}
    
    # Tenta múltiplas estratégias de upload
    Run Keyword And Ignore Error    Choose File    ${input_foto}    ${caminho_foto}


    
Clicar em submit
    Click Element    ${Button_submit} 

Fechar site
    Close Browser


*** Test Cases ***
Cenário 1: Preencher Formulário ADS
    Abrir site ADS
    Fechar Pop-up de Cookies
    Preencher campos
    Selecionar gênero    FeMale
    Selecionar Hobbies    Movies
    Fechar Anúncio
    Selecionar Idioma    Italian
    Selecionar Skills    Python
    Selecionar country    Select Country
    Selecionar País    Japan
    Preencher Ano de Nascimento
    Preencher Mês de Nascimento
    Preencher Dia de Nascimento
    Selecionar Foto    ${CAMINHO_FOTO}
    Clicar em submit
    Fechar site