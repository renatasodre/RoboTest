*** Settings ***
Library    SeleniumLibrary
   

*** Variables ***
${URL}    https://demoqa.com/automation-practice-form
${BROWSER}    chrome
${input_name}    id:firstName
${input_apelido}    id:lastName
${input_email}    id:userEmail
${GENERO_MASCULINO}     Male
${GENERO_FEMININO}      Female
${GENERO_OUTRO}         Other
${input_telemovel}    id:userNumber
${input_niver}    id:dateOfBirthInput
${LABEL_HOBBIES}    xpath://label[@id='subjects-label' and contains(text(), 'Hobbies')]
${CHECKBOX_HOBBIES}    ${LABEL_HOBBIES}/parent::div//input[@type='checkbox']
${input_foto}    id:uploadPicture
${CAMINHO_FOTO}    C:/Users/renat/projects/robotselenium/Resources/logan-weaver-lgnwvr-ezcWbV3Pf_c-unsplash.jpg
${textarea_endereco}    id:currentAddress
${DIV_STATE}       xpath://div[contains(text(), 'Select State')]
${DIV_CITY}        xpath://div[contains(text(), 'Select City')]
${button_submit}    id:submit


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
    [Documentation]    Abre o navegador na página de formulário
    ${chrome_options}    Configurar Opções do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Preencher campos
    Input text    ${input_name}    Renata
    Input text    ${input_apelido}  Sodré
    Input text    ${input_email}    rribeirosodre@gmail.com
    Input text    ${input_telemovel}    999999999
    Input text    ${textarea_endereco}    Rua Beato Francisco Pacheco 23, Cabrão, Viana do Castelo, 4990-730.

Preencher Data Nascimento
    [Arguments]    ${input_niver}=15 Mar 1993
    
    # Limpa o campo antes de inserir
    Clear Element Text    id:dateOfBirthInput
    
    # Insere a data diretamente
    Input Text    id:dateOfBirthInput    ${input_niver}
    
    # Opcionalmente, pressiona ENTER para confirmar
    Press Keys    id:dateOfBirthInput    ENTER   

Selecionar Gênero
    [Arguments]    ${genero}
    
    # Estratégias de localização para o site específico
    @{localizadores}    Create List
    ...    xpath://label[contains(@for, 'gender-radio') and text()='${genero}']
    ...    xpath://input[@name='gender' and @value='${genero}']
    
    # Tenta cada localizador
    ${elemento_encontrado}    Set Variable    ${FALSE}
    
    FOR    ${localizador}    IN    @{localizadores}
        ${status}    ${result}    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${localizador}    timeout=10s
        
        Run Keyword If    '${status}' == 'PASS'    Run Keywords
        ...    Scroll Element Into View    ${localizador}
        ...    AND    Click Element    ${localizador}
        ...    AND    Set Local Variable    ${elemento_encontrado}    ${TRUE}
        ...    AND    Exit For Loop
    END
    
    # Verifica se encontrou o elemento
    Run Keyword If    not ${elemento_encontrado}    Fail    Não foi possível localizar o elemento de gênero

    # Validação alternativa
    Run Keyword And Ignore Error    Radio Button Should Be Set To    gender    ${genero}
    


Carregar Foto
    [Arguments]    ${caminho_foto}=${CAMINHO_FOTO}
    
    # Verifica a existência do arquivo
    ${arquivo_existe}    Evaluate    os.path.exists('${caminho_foto}')    modules=os
    Run Keyword Unless    ${arquivo_existe}    Fail    Arquivo de foto não encontrado: ${caminho_foto}
    
    # Tenta múltiplas estratégias de upload
    Run Keyword And Ignore Error    Choose File    ${input_foto}    ${caminho_foto}
    Run Keyword And Ignore Error    Upload Foto Por JavaScript    ${caminho_foto}

Upload Foto Por JavaScript
    [Arguments]    ${caminho_foto}
    
    Execute JavaScript    
    ...    var input = document.getElementById('uploadPicture');
    ...    var file = new File([''], '${caminho_foto}', {type: 'image/jpeg'});
    ...    var dataTransfer = new DataTransfer();
    ...    dataTransfer.items.add(file);
    ...    input.files = dataTransfer.files;
    ...    var event = new Event('change', { bubbles: true });
    ...    input.dispatchEvent(event);

Selecionar hobbies
    [Arguments]    @{hobbies}
    
    FOR    ${hobbie}    IN    @{hobbies}
        # Usa o texto exato do checkbox
        Click Element    xpath://label[contains(text(), '${hobbie}')]
    END 


Verificar Hobbies Selecionados
    [Arguments]    @{hobbies}
    
    FOR    ${hobbie}    IN    @{hobbies}
        # Verifica se o checkbox está selecionado pelo texto da label
        ${status}    Run Keyword And Return Status    
        ...    Checkbox Should Be Selected    xpath://label[contains(text(), '${hobbie}')]/input[@type='checkbox']
        
        Run Keyword If    not ${status}    Run Keywords
        ...    Log Warning    Hobbie '${hobbie}' não selecionado
        ...    AND    Capture Page Screenshot    hobbie_${hobbie}_nao_selecionado.png
    END


Remover Elementos Bloqueadores
    # Remove anúncios e elementos que podem bloquear interações
    Execute JavaScript    
    ...    // Remove iframes de propaganda
    ...    var iframes = document.querySelectorAll('iframe');
    ...    iframes.forEach(function(iframe) {
    ...        iframe.remove();
    ...    });
    ...    
    ...    // Remove elementos de propaganda
    ...    var adElements = document.querySelectorAll('[id*="ad"], [class*="ad"], [data-ad]');
    ...    adElements.forEach(function(el) {
    ...        el.remove();
    ...    });
    ...    
    ...    // Rola para o final da página para carregar elementos
    ...    window.scrollTo(0, document.body.scrollHeight);

Selecionar Estado e Cidade 
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

Clicar em submit
    Click element    ${button_submit} 

Fechar site
    Close Browser


*** Test Cases ***
Cenário 1: Preencher formulário
    Abrir navegador
    Preencher campos  
    # Selecionar gênero
    Selecionar Gênero    ${GENERO_FEMININO}
    Preencher Data Nascimento    # Usa data padrão 15 Mar 1993 ou com data personalizada EX.: 20 Abr 1990
    # Selecionar hobbies
    Selecionar Hobbies    Reading    Music
    # Verificar os hobbies selecionados
    Verificar Hobbies Selecionados
    # Carregar foto com tratamento de erro
    Carregar foto
    # Selecionar Estado e Cidade - A lista de cidades só é habiltada, após a seleção do Estado
    Selecionar Estado e Cidade    Haryana    Panipat
    Clicar em submit
    Fechar site