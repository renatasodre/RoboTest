*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${URL}                  https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${BROWSER}              chrome
${INPUT_NAME}           name:username
${INPUT_APELIDO}        name:password
${BUTTON_SUBMIT}        xpath://button[@type='submit']
${BUTTON_TEMPO}         css:button.orangehrm-attendance-card-action
${INPUT_COMENTARIO}     css:textarea.oxd-textarea.oxd-textarea--active
${BUTTON_IN}            css:button.oxd-button--secondary.orangehrm-left-space


*** Test Cases ***
Cenário 1: Fazer Login No OrangeHRM
    Abrir Navegador
    Preencher Campos
    Clicar No Botão De Login

Cenário 2: Registrar Comentário De Banco De Horas
    Clicar No Botão De Registar Tempo De Trabalho
    Adicionar Comentário De Banco De Horas
    ...    Banco de Horas - Teste de Registro: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto.
    Submeter Tempo

Cenário 3: Encerrar Sessão
    Fechar Site


*** Keywords ***
Configurar Opções Do Navegador
    [Documentation]    Configura opções do Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Adiciona argumentos
    Call Method    ${options}    add_argument    --disable-extensions    # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups
    Call Method    ${options}    add_argument    --disable-notifications    # Desabilita notificações
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance

    RETURN    ${options}

Abrir Navegador
    [Documentation]    Abre o navegador na página de login do OrangeHRM.
    ${chrome_options}    Configurar Opções Do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Preencher Campos
    [Documentation]    Preenche os campos de login no OrangeHRM.
    Wait Until Element Is Visible    ${input_name}    10s
    Input Text    ${input_name}    Admin
    Input Text    ${input_apelido}    admin123

Clicar No Botão De Login
    [Documentation]    Clica no botão de login para acessar o OrangeHRM.
    Click Button    ${button_submit}

Clicar No Botão De Registar Tempo De Trabalho
    [Documentation]    Clica no botão para registrar o tempo de trabalho.
    Wait Until Page Contains Element    ${button_tempo}    10s
    Click Button    ${button_tempo}

Adicionar Comentário De Banco De Horas
    [Documentation]    Adiciona um comentário ao campo de banco de horas.
    [Arguments]    ${comentario}
    Wait Until Element Is Visible    ${input_comentario}    10s
    Execute JavaScript    document.querySelector('textarea.oxd-textarea.oxd-textarea--active').scrollIntoView()
    Sleep    0.5s
    Input Text    ${input_comentario}    ${comentario}

Submeter Tempo
    [Documentation]    Clica no botão para submeter o tempo registrado.
    Wait Until Element Is Visible    ${button_in}    30s
    Execute JavaScript    document.querySelector('button.oxd-button--secondary.orangehrm-left-space').scrollIntoView()
    Sleep    0.5s
    Click Button    ${button_in}

Fechar Site
    [Documentation]    Fecha o navegador.
    Close Browser
