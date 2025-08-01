*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem


*** Variables ***
${URL}                          https://demo.automationtesting.in/Register.html
${BROWSER}                      chrome
${INPUT_NOME}                   xpath=//input[@type='text' and @placeholder='First Name' and @ng-model='FirstName']
${INPUT_APELIDO}                xpath=//input[@type='text' and @placeholder='Last Name' and @ng-model='LastName']
${TEXTAREA_ENDERECO}            xpath=//textarea[@ng-model='Adress']
${INPUT_EMAIL}                  xpath=//input[@type='email' and @ng-model='EmailAdress']
${INPUT_TELEFONE}               xpath=//input[@type='tel' and @ng-model='Phone']
${GENERO_MASCULINO}             Male
${GENERO_FEMININO}              FeMale
${LABEL_HOBBIES}                xpath://label[@type='checkbox' and contains(text(), 'Hobbies')]
${CHECKBOX_HOBBIES}             ${LABEL_HOBBIES}/parent::div//input[@type='checkbox']
${DIV_IDIOMA}                   id:msdd
${SELECT_SKILLS}                id:Skills
${COUNTRY}                      id:countries
${SELECT_PAIS}                  xpath=//span[contains(@class, 'select2-selection--single')]
${ANO}                          id:yearbox
${MES}                          xpath=//select[@ng-model='monthbox']
${DIA}                          id:daybox
${INPUT_SENHA}                  id:firstpassword
${INPUT_CONFIRMACAO_SENHA}      id:secondpassword
${PROJETO_DIR}                  ${EXECDIR}
${CAMINHO_FOTO}                 ${PROJETO_DIR}${/}Resources${/}logan-weaver-lgnwvr-ezcWbV3Pf_c-unsplash.jpg
${INPUT_FOTO}                   id:imagesrc
${BUTTON_SUBMIT}                id:submit


*** Test Cases ***
Cenário 1: Preencher Formulário ADS
    Abrir Site ADS
    Fechar Pop-Up De Cookies
    Preencher Campos
    Selecionar Gênero    FeMale
    Selecionar Hobbies    Movies
    Fechar Anúncio
    Selecionar Idioma    Italian
    Selecionar Skills    Python
    Selecionar Country    Select Country
    Selecionar País    Japan
    Preencher Ano De Nascimento
    Preencher Mês De Nascimento
    Preencher Dia De Nascimento
    Selecionar Foto
    Clicar Em Submit
    Fechar Site


*** Keywords ***
Configurar Opções Do Navegador
    [Documentation]    Configura as opções do navegador Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    #Adiciona argumentos para o Chrome
    Call Method    ${options}    add_argument    --disable-extensions    # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups
    Call Method    ${options}    add_argument    --disable-notifications    # Desabilita notificações
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance

    RETURN    ${options}

Abrir Site ADS
    [Documentation]    Abre o navegador na página de home
    ${chrome_options}    Configurar Opções Do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Fechar Pop-Up De Cookies
    [Documentation]    Fecha o pop-up de consentimento de cookies
    Wait Until Page Contains Element
    ...    xpath=//p[contains(@class, 'fc-button-label') and contains(text(), 'Do not consent')]
    ...    timeout=10s
    Click Element    xpath=//p[contains(@class, 'fc-button-label') and contains(text(), 'Do not consent')]

Preencher Campos
    [Documentation]    Preenche os campos do formulário
    Input Text    ${input_nome}    Renata
    Input Text    ${input_apelido}    Sodré
    Input Text    ${textarea_endereco}    Rua Beato Francisco Pacheco 23, Cabrão, Viana do Castelo, 4990-730.
    Input Text    ${input_email}    rribeirosodre@gmail.com
    Input Text    ${input_telefone}    9999999999
    Input Text    ${input_senha}    eiAbA!#ZYxZ4$U
    Input Text    ${input_confirmacao_senha}    eiAbA!#ZYxZ4$U

Selecionar Gênero
    [Documentation]    Seleciona o gênero no formulário
    [Arguments]    ${genero}
    Click Element    xpath=//input[@name='radiooptions' and @value='${genero}']

Selecionar Hobbies
    [Documentation]    Seleciona os hobbies no formulário
    [Arguments]    ${hobby}
    Click Element    xpath=//input[@type='checkbox' and @value='${hobby}']

Selecionar Idioma
    [Documentation]    Seleciona o idioma no formulário
    [Arguments]    ${idioma}
    Click Element    ${div_idioma}
    Wait Until Element Is Visible    xpath=//a[text()='${idioma}']    timeout=10s
    Scroll Element Into View    xpath=//a[text()='${idioma}']
    Click Element    xpath=//a[text()='${idioma}']
    Click Element    xpath=//header[@id='header']
    Sleep    1s

Selecionar País
    [Documentation]    Seleciona o país no formulário usando Select2
    [Arguments]    ${pais}
    Wait Until Element Is Visible    xpath=//span[contains(@class, 'select2-selection--single')]    timeout=10s
    Click Element    xpath=//span[contains(@class, 'select2-selection--single')]
    Wait Until Element Is Visible    xpath=//input[contains(@class, 'select2-search__field')]    timeout=5s
    Input Text    xpath=//input[contains(@class, 'select2-search__field')]    ${pais}
    Press Keys    xpath=//input[contains(@class, 'select2-search__field')]    ENTER
    Element Should Contain
    ...    xpath=//span[contains(@class, 'select2-selection__rendered')]
    ...    ${pais}
    ...    O país '${pais}' não foi selecionado corretamente

Selecionar Country
    [Documentation]    Seleciona o país no formulário
    [Arguments]    ${outropais}
    Click Element    ${country}
    Select From List By Label    ${country}    ${outropais}
    Sleep    1s
    Element Should Contain
    ...    ${country}
    ...    ${outropais}
    ...    Fail
    ...    O país '${outropais}' não foi selecionado corretamente

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
    Element Should Contain
    ...    ${select_skills}
    ...    ${skill}
    ...    Fail
    ...    A skill '${skill}' não foi selecionada corretamente

Preencher Ano De Nascimento
    [Documentation]    Preenche o ano de nascimento no formulário
    [Arguments]    ${ano}=1993
    Select From List By Label    id:yearbox    ${ano}

Preencher Mês De Nascimento
    [Documentation]    Preenche o mês de nascimento no formulário
    [Arguments]    ${mes}=March
    Select From List By Label    xpath=//select[@ng-model='monthbox']    ${mes}

Preencher Dia De Nascimento
    [Documentation]    Preenche o dia de nascimento no formulário
    [Arguments]    ${dia}=15
    Select From List By Label    id:daybox    ${dia}

Selecionar Foto
    [Documentation]    Seleciona uma foto para upload
    ${CAMINHO_ABSOLUTO}    Normalize Path    ${CAMINHO_FOTO}
    Open Browser    https://demoqa.com/automation-practice-form    chrome
    Maximize Browser Window
    Sleep    1s
    Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
    Wait Until Element Is Visible    id=uploadPicture    10s
    Choose File    id=uploadPicture    ${CAMINHO_ABSOLUTO}

Clicar Em Submit
    [Documentation]    Clica no botão de submit do formulário
    Click Element    ${Button_submit}

Fechar Site
    [Documentation]    Fecha o navegador
    Close Browser
