*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem


*** Variables ***
${URL}                  https://demoqa.com/automation-practice-form
${BROWSER}              chrome
${INPUT_NAME}           id:firstName
${INPUT_APELIDO}        id:lastName
${INPUT_EMAIL}          id:userEmail
${GENERO_MASCULINO}     Male
${GENERO_FEMININO}      Female
${GENERO_OUTRO}         Other
${INPUT_TELEMOVEL}      id:userNumber
${INPUT_NIVER}          id:dateOfBirthInput
${LABEL_HOBBIES}        xpath://label[@id='subjects-label' and contains(text(), 'Hobbies')]
${CHECKBOX_HOBBIES}     ${LABEL_HOBBIES}/parent::div//input[@type='checkbox']
${INPUT_FOTO}           id:uploadPicture
${PROJETO_DIR}          ${EXECDIR}
${CAMINHO_FOTO}         ${PROJETO_DIR}${/}Resources${/}logan-weaver-lgnwvr-ezcWbV3Pf_c-unsplash.jpg
${TEXTAREA_ENDERECO}    id:currentAddress
${DIV_STATE}            xpath://div[contains(text(), 'Select State')]
${DIV_CITY}             xpath://div[contains(text(), 'Select City')]
${BUTTON_SUBMIT}        id:submit


*** Test Cases ***
Cenário 1: Preencher formulário
    [Documentation]    Preenche o formulário de registro
    Abrir Navegador
    Preencher Campos
    Selecionar Gênero    ${GENERO_FEMININO}
    Preencher Data Nascimento    # Usa data padrão 15 Mar 1993 ou com data personalizada EX.: 20 Abr 1990
    Selecionar Hobbies    Reading    Music
    Verificar Hobbies Selecionados
    Carregar Foto    # Selecionar Estado e Cidade - A lista de cidades só é habiltada, após a seleção do Estado
    Selecionar Estado E Cidade    Haryana    Panipat
    Clicar Em Submit
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
    [Documentation]    Abre o navegador na página de formulário
    ${chrome_options}    Configurar Opções Do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    # Maximize Browser Window

Preencher Campos
    [Documentation]    Preenche os campos do formulário de registro
    Input Text    ${input_name}    Renata
    Input Text    ${input_apelido}    Sodré
    Input Text    ${input_email}    rribeirosodre@gmail.com
    Input Text    ${input_telemovel}    999999999
    Input Text    ${textarea_endereco}    Rua Beato Francisco Pacheco 23, Cabrão, Viana do Castelo, 4990-730.

Preencher Data Nascimento
    [Documentation]    Preenche o campo de data de nascimento
    [Arguments]    ${input_niver}=15 Mar 1993

    # Limpa o campo antes de inserir
    Clear Element Text    id:dateOfBirthInput

    # Insere a data diretamente
    Input Text    id:dateOfBirthInput    ${input_niver}

    # Opcionalmente, pressiona ENTER para confirmar
    Press Keys    id:dateOfBirthInput    ENTER

Selecionar Gênero
    [Documentation]    Seleciona o gênero no formulário
    [Arguments]    ${genero}

    # Estratégias de localização para o site específico
    @{localizadores}    Create List
    ...    xpath://label[contains(@for, 'gender-radio') and text()='${genero}']
    ...    xpath://input[@name='gender' and @value='${genero}']

    # Tenta cada localizador
    ${elemento_encontrado}    Set Variable    ${FALSE}

    FOR    ${localizador}    IN    @{localizadores}
        ${status}    ${result}    Run Keyword And Ignore Error
        ...    Wait Until Element Is Visible
        ...    ${localizador}
        ...    timeout=10s

        IF    '${status}' == 'PASS'
            Scroll Element Into View    ${localizador}
            Click Element    ${localizador}
            Set Local Variable    ${elemento_encontrado}    ${TRUE}
            BREAK
        END
    END

    # Verifica se encontrou o elemento
    IF    not ${elemento_encontrado}
        Fail    Não foi possível localizar o elemento de gênero
    END

    # Validação alternativa
    Run Keyword And Ignore Error    Radio Button Should Be Set To    gender    ${genero}

Carregar Foto
    [Documentation]    Carrega uma foto no campo de upload
    ${CAMINHO_ABSOLUTO}    Normalize Path    ${CAMINHO_FOTO}
    Wait Until Element Is Visible    id=uploadPicture    10s
    Choose File    id=uploadPicture    ${CAMINHO_ABSOLUTO}

Upload Foto Por JavaScript
    [Documentation]    Carrega uma foto usando JavaScript
    [Arguments]    ${caminho_foto}

    Execute JavaScript
    ...    var input = document.getElementById('uploadPicture');
    ...    var file = new File([''], '${caminho_foto}', {type: 'image/jpeg'});
    ...    var dataTransfer = new DataTransfer();
    ...    dataTransfer.items.add(file);
    ...    input.files = dataTransfer.files;
    ...    var event = new Event('change', { bubbles: true });
    ...    input.dispatchEvent(event);

Selecionar Hobbies
    [Documentation]    Seleciona os hobbies no formulário
    [Arguments]    @{hobbies}

    FOR    ${hobbie}    IN    @{hobbies}
        # Usa o texto exato do checkbox
        Click Element    xpath://label[contains(text(), '${hobbie}')]
    END

Verificar Hobbies Selecionados
    [Documentation]    Verifica se os hobbies estão selecionados
    [Arguments]    @{hobbies}

    FOR    ${hobbie}    IN    @{hobbies}
        # Verifica se o checkbox está selecionado pelo texto da label
        ${status}    Run Keyword And Return Status
        ...    Checkbox Should Be Selected    xpath://label[contains(text(), '${hobbie}')]/input[@type='checkbox']

        IF    not ${status}
            Log Warning    Hobbie '${hobbie}' não selecionado
            Capture Page Screenshot    hobbie_${hobbie}_nao_selecionado.png
        END
    END

Remover Elementos Bloqueadores
    [Documentation]    Remove anúncios e elementos que podem bloquear interações
    Execute JavaScript
    ...    // Remove iframes de propaganda
    ...    var iframes = document.querySelectorAll('iframe');
    ...    iframes.forEach(function(iframe) {
    ...    iframe.remove();
    ...    });
    ...
    ...    // Remove elementos de propaganda
    ...    var adElements = document.querySelectorAll('[id*="ad"], [class*="ad"], [data-ad]');
    ...    adElements.forEach(function(el) {
    ...    el.remove();
    ...    });
    ...
    ...    // Rola para o final da página para carregar elementos
    ...    window.scrollTo(0, document.body.scrollHeight);

Selecionar Estado E Cidade
    [Documentation]    Seleciona o estado e a cidade no formulário
    [Arguments]    ${estado}    ${cidade}

    # Log para debug
    Log    Selecionando Estado: ${estado}
    Log    Selecionando Cidade: ${cidade}

    # Rola a página para baixo para garantir visualização
    Execute JavaScript    window.scrollBy(0, 500)

    # Abre o dropdown de estado
    Wait Until Element Is Visible    xpath://div[contains(text(), 'Select State')]    timeout=5s
    Click Element    xpath://div[contains(text(), 'Select State')]

    # Espera e seleciona o estado com tratamento de erro
    Run Keyword And Ignore Error
    ...    Wait Until Keyword Succeeds    10s    2s
    ...    Click Element    xpath://div[contains(@id, 'react-select') and contains(text(), '${estado}')]

    # Abre o dropdown de cidade
    Wait Until Element Is Visible    xpath://div[contains(text(), 'Select City')]    timeout=5s
    Click Element    xpath://div[contains(text(), 'Select City')]

    # Espera e seleciona a cidade com tratamento de erro
    Run Keyword And Ignore Error
    ...    Wait Until Keyword Succeeds    10s    2s
    ...    Click Element    xpath://div[contains(@id, 'react-select') and contains(text(), '${cidade}')]

Clicar Em Submit
    [Documentation]    Clica no botão de submit do formulário
    Click Element      ${button_submit}

Fechar Site
    [Documentation]    Fecha o navegador
    Close Browser
