*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${URL}                          https://bugbank.netlify.app/#
${BROWSER}                      chrome
${button_registro}              xpath://button[@type='button' and contains(text(), 'Registrar')]
${input_email}                  id:email
${input_nome}                   id:name
${input_senha}                  id:password
${input_confirmacao_senha}      id:passwordConfirmation
${label_saldo}                  id:toggleAddBalance
${button_cadastrar}             xpath://button[@type='submit' and contains(text(), 'Cadastrar')]
${opção_voltar_login}           id:btnBackButton



*** Keywords ***
Configurar Opções do Navegador
    # Configura opções do Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Adiciona argumentos
    Call Method    ${options}    add_argument    --disable-extensions    # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups
    Call Method    ${options}    add_argument    --disable-notifications    # Desabilita notificações
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance

    RETURN    ${options}

Abrir Home do Site do BugBank
    # Abre o navegador na página de home
    ${chrome_options}    Configurar Opções do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Clicar no Botão Registrar
    # Estratégias múltiplas para clicar no botão
    Wait Until Page Contains Element    ${button_registro}    timeout=30s

    # Tenta clicar de diferentes formas
    Run Keyword And Ignore Error    Click Element    ${button_registro}
    Run Keyword And Ignore Error
    ...    Execute JavaScript
    ...    document.querySelector('button[type="button"]:contains("Registrar")').click()

Preencher Campos
    # Input Text    xpath://input[@placeholder='Informe seu e-mail']    rribeirosodre@gmail.com
    Input Text    css:.card__register input[name='email']    rribeirosodre@gmail.com
    Input Text    css:.card__register input[name='name']    Renata Sodré
    Input Password    css:.card__register input[name='password']    eiAbA!#ZYxZ4$U
    Input Password    css:.card__register input[name='passwordConfirmation']    eiAbA!#ZYxZ4$U

    Execute JavaScript    arguments[0].value = 'rribeirosodre@gmail.com'    ARGUMENTS    ${input_email}
    Execute JavaScript    arguments[0].value = 'Renata Sodré'    ARGUMENTS    ${input_nome}
    Execute JavaScript    arguments[0].value = 'eiAbA!#ZYxZ4$U'    ARGUMENTS    ${input_senha}
    Execute JavaScript    arguments[0].value = 'eiAbA!#ZYxZ4$U'    ARGUMENTS    ${input_confirmacao_senha}

Clicar no Botão Cadastrar
    # Estratégias múltiplas para clicar no botão
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    2s

    # Tenta clicar de várias formas
    Run Keyword And Ignore Error    Click Element    ${button_cadastrar}
    Execute JavaScript
    ...    var botao = document.querySelector('button[type="submit"]');
    ...    if (botao) {
    ...    botao.click();
    ...    }

Clicar no Botão de Saldo
    [Arguments]    ${criar_com_saldo}=${FALSE}

    # Espera e verifica o estado do toggle
    Wait Until Page Contains Element    ${label_saldo}    timeout=30s
    Sleep    2s

    ${estado_atual}    Get Element Attribute    ${label_saldo}    class

    IF    ${criar_com_saldo} and 'ativo' not in '${estado_atual}'
        Click Element    ${label_saldo}
    END
    IF    not ${criar_com_saldo} and 'ativo' in '${estado_atual}'
        Click Element    ${label_saldo}
    END

Voltar ao Login
    # Estratégia para lidar com elementos que bloqueiam o clique
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    2s

    # Tenta clicar de várias formas
    Run Keyword And Ignore Error    Click Element    ${opção_voltar_login}
    Execute JavaScript
    ...    var botao = document.getElementById('btnBackButton');
    ...    if (botao) {
    ...    botao.click();
    ...    }

Fechar site
    Close Browser


*** Test Cases ***
Cenário 1: Acessar página de registro
    Abrir Home do Site do BugBank
    Clicar no Botão Registrar

Cenário 2: Formulário de Registro
    Preencher campos

Cenário 3: Criar conta com saldo
    Clicar no botão de saldo    ${TRUE}

Cenário 4: Cadastrar e Voltar para a página Home
    Clicar no Botão Cadastrar
    Voltar ao Login
    Fechar site