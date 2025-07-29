*** Settings ***
Library           SeleniumLibrary


*** Variables ***
${URL}    https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${BROWSER}    chrome
${input_name}    name:username
${input_apelido}    name:password
${button_submit}    xpath://button[@type='submit']
${button_tempo}    css:button.orangehrm-attendance-card-action
${input_comentario}    css:textarea.oxd-textarea.oxd-textarea--active
${button_in}    css:button.oxd-button--secondary.orangehrm-left-space


*** Keywords ***
Configurar Opções do Navegador
    [Documentation]    Configura opções do Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Adiciona argumentos
    Call Method    ${options}    add_argument    --disable-extensions       # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups
    Call Method    ${options}    add_argument    --disable-notifications     # Desabilita notificações
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance

    RETURN    ${options}

Abrir Navegador
    # Abre o navegador na página de formulário
    ${chrome_options}    Configurar Opções do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Preencher campos
    Wait Until Element Is Visible    ${input_name}    10s
    Input text    ${input_name}   Admin
    Input text    ${input_apelido}   admin123


Clicar no Botão de Login
    Click Button    ${button_submit}

Clicar no Botão de Registar Tempo de Trabalho
    Wait Until Page Contains Element    ${button_tempo}    10s
    Click Button    ${button_tempo}

Adicionar Comentário de Banco de Horas
    [Arguments]    ${comentario}
    Wait Until Element Is Visible    ${input_comentario}    10s
    Execute JavaScript    document.querySelector('textarea.oxd-textarea.oxd-textarea--active').scrollIntoView()
    Sleep    0.5s
    Input Text    ${input_comentario}    ${comentario}


Submeter Tempo
    Wait Until Element Is Visible    ${button_in}    30s
    Execute JavaScript    document.querySelector('button.oxd-button--secondary.orangehrm-left-space').scrollIntoView()
    Sleep    0.5s
    Click Button    ${button_in}


Fechar site
    Close Browser


*** Test Cases ***
Cenário 1: Fazer Login no OrangeHRM
    Abrir Navegador
    Preencher campos
    Clicar no Botão de Login

Cenário 2: Registar Comentário de Banco de Horas
    Clicar no Botão de Registar Tempo de Trabalho
    Adicionar Comentário de Banco de Horas    Banco de Horas - Teste de Registro: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.
    Submeter Tempo

Cenário 3: Encerrar Sessão
    Fechar site
