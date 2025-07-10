*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections
Library    RequestsLibrary

   
# Library    Collections
# Library    BuiltIn
# Library    DateTime


# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Variables/Global_variables.robot





*** Keywords ***

Page d'accueil de Conserto 
    [Arguments]     ${Title}  
    Maximize Brows
    Log  Page Accueil - vérif titre et éléments du menu nav : 
    Verif title   ${Title}
    # # Verif Elements bloc nav 
    # Conditions menu nav     Positive
    
    # Log  Page Accueil - vérif logo et quelques éléments de la page : 
    # Vérifier logo   ${Conserto}
    # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    # Verif ilots
    
Page Accueil verif titre 
    # [Arguments]     ${Title}  
    Log  Page Accueil - vérif du titre attendu :  
    Verif title   ${Title_1} 
    Fermer Le Popup S'il Apparaît


Page d'accueil de Conserto cas 2 
    [Arguments]     ${Title}  
    # Maximize Brows
    
    Log  Page Accueil - vérif titre et éléments du menu nav : 
    Verif title   ${Title}
    # Verif Elements bloc nav 
    Conditions menu nav     Positive
    Verif positive techo2  ${Positif_Techo_info}   ${Clients_texte}

    Log  Page Accueil - vérif logo et quelques éléments de la page : 
    Vérifier logo   ${Conserto}
    # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    Verif ilots
 

Verif title 
    [Arguments]     ${Title} 
    ${html}=    Get Source
    FOR    ${titre}    IN    ${Title}
        Should Contain    ${html}    ${titre}
        ${log}=    Set Variable    ${titre}
        Log    ${log}
        Log To console    ${log}   
        Title Should Be   ${Title}
    END


Autres verifs Idnow 
    Barre de Nav Idnow    ${Barre_de_nav_Idnow}    
    Barre de Nav Idnow    ${Barre_de_nav_Idnow2}
    Action nav Idnow      Secteurs   Assurances
    Afficher Tous Les cas     Solutions    ${Solutions}[0]
    
Verif textes page acceuil 
    [Arguments]     ${texte}      ${Texte2}      
    Wait Until Element Is Visible    xpath=//div//p//span[text()='${texte}']      10 
    ${texte_value}=    Get text    xpath=//div//p//span[text()='${texte}'] 
    Wait Until Element Is Visible    xpath=//div//p//span[text()='${texte2}']      10
    ${text_values}=   Get text    xpath=//div//p//span[text()='${Texte2}']
    Wait Until Keyword Succeeds	    5s	3s   Capture Page Screenshot

Verif Elements bloc nav 
    [Arguments]    # ${Posit_texte}   ${Tech_texte}   ${Cli_texte}   ${Aca_texte}   ${Blo_texte}   ${Cont_texte}
    Log   1ère méthode de vérif élements du bloc nav :
    Wait Until Element Is Visible    ${Barre_de_nav}      10 
    ${nav_value}=    Get text    ${Barre_de_nav} 
    # Capture element screenshot    ${Barre_de_nav}
    Capture Element Et Sauvegarde      ${Barre_de_nav}    Screenshot   nav
    # Element Should Contain     ${Barre_de_nav}    ${Nav_texte}

    Log   2ème méthode de vérif élements du bloc nav : 
    Element Should Contain    ${Barre_de_nav}      ${Positive_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Techo_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Clients_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Academy_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Blog_texte}   
    Element Should Contain    ${Barre_de_nav}      ${Contact_texte}


Verif positive techologie  
    [Arguments]    ${texte}  # ${texte2}
    Log     vérif présence du texte positive technoligie
    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10  
    ${text}=    Set Variable   positive technologie   # ${Positif_Techo_info}     # Positive Technologie
    ${textes}=    Set Variable   Positive\nTechnologie
    ${xpath1}=   Set Variable    xpath=//h1[contains(text(), "${Positif_Techo_info}")] 
    ${xpath2}=   Set Variable    xpath=//h1[translate(normalize-space(.), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '${text}'] 
    ${xpath3}=   Set Variable    xpath=//div[normalize-space(.)="${texte}"] 
    ${xpath4}=   Set Variable    xpath=//div[@class="words-container" and contains(normalize-space(.), "${texte}")]
    ${xpath5}=   Set Variable    xpath=//div[@class="first-word has-primary-color"]
    ${xpath6}=   Set Variable    xpath=//div[@class="second-word has-dark-color"]

    Wait Until Element Is Visible    ${Conserto}    10
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Conserto}

    IF    ${status}
        Log    Méthode 1 - On constate bien que "${texte}" est bien visible. 
        Wait Until Page Contains Element    ${xpath1}    20s
        Page Should Contain Element    ${xpath1}
        Wait Until Page Contains Element    ${xpath2}    15s
        
        Log    Méthode 2 - Chercher un div qui a pour texte combiné "Positif Technologie"
        Wait Until Page Contains Element       ${xpath3}     10s
        Capture Element Screenshot     ${xpath3}
        Element Text Should Be    ${xpath3}    ${textes} 


        Log    Méthode 3 - Version robuste (ignorer les espaces multiples, sauts de ligne, etc.)
        Wait Until Page Contains Element       ${xpath4}    10s
        Capture Element Screenshot     ${xpath4}
        Element Text Should Be    ${xpath4}    ${textes} 
        
        Log    Méthode 4 - Vérification des deux sous-éléments séparément
        Element Should Contain    ${xpath5}    ${Posit_texte}      # Positive 
        Element Should Contain    ${xpath6}    ${Tech_texte}       # Technologie

        Log    Méthode 5 - Complets 
        ${part1}=    Get Text    ${xpath5}
        ${part2}=    Get Text    ${xpath6}
        Should Be Equal    ${part1} ${part2}    ${Positif_Techo_info}
        # Log To console     ${Positif_Techo_info}

    ELSE
        Log   L'élement "${texte}" attendu non trouvé. Tentative de Screenshot.   
        # Run Keyword    Verif positive techo   ${Clients}   ${texte2} 
        # Run Keyword And Ignore Error    Capture Page Screenshot
        Run Keyword And Ignore Error    Capture Page Et Sauvegarde     Screenshot   capture_Absence_PositiveTecho
    END

Vérifier logo conserto 
    Log     vérif présence du logo
    Vérifier logo    ${Conserto}
    Wait Until Keyword Succeeds    10 x    2 s    Fermer Le Popup S'il Apparaît


Verif positive techo
    [Arguments]    ${xpath}    ${texte_attendu} 
    Verifier Titre Visible     ${xpath}    ${texte_attendu}  



Page acceuil verifs ilots et agences 
    [Arguments]    ${text} 
    ${xpath}=    Set Variable    ${Accueil_container}
    Wait Until Element Is Visible    ${xpath}    10
    Scroll Element Into View     ${xpath}

    ${Tous}=    Get Text    ${xpath}
    ${Texte1}=    Get Text    ${Accueil_Texte_container}  
    ${Texte_tous}=    Get Text    ${Accueil_Ilots_container}   
    Element Text Should Be    ${Accueil_Texte_container}    ${text}    
    # Capture Element Et Sauvegarde  ${Accueil_Ilots_list}  Screenshot  capture_ilots_accueil
    Verif des 5 ilots
    Verif agences    ${Accueil_agences}    ${Accueil_text_agences}
    Actu agences     ${Accueil_actu_agences}



Actions agence par agence
    [Arguments]    ${index}
    Activer L'Élément Par Index    ${index}




Activer L'Élément Par Index
    [Arguments]    ${index} 
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'content') and @data-index='${index}']    10
    Scroll Element Into View     xpath=//div[contains(@class, 'content') and @data-index='${index}']
    Wait Until Keyword Succeeds    2 x    2 s    Click Element    xpath=//div[contains(@class, 'content') and @data-index='${index}']
    # Wait Until Element Attribute Contains    xpath=//div[@data-index='${index}']    class    active    timeout=10s
    

Vérifier Tous Les Contenus Actifs
    [Arguments]    @{donnees_villes}
    FOR    ${donnee}    IN    @{donnees_villes}
        ${index}=          Set Variable    ${donnee}[0]
        ${ville}=          Set Variable    ${donnee}[1]
        ${titre}=          Set Variable    ${donnee}[2]
        ${commentaire}=    Set Variable    ${donnee}[3]

        Log To Console    \n🔍 Vérification de ${ville} (index: ${index})
        Vérifier Le Contenu Actif Correspond    ${index}    ${ville}    ${titre}    ${commentaire}
    END



Vérification De Toutes Les Agences 
    Wait Until Keyword Succeeds    10 x    2 s    Fermer Le Popup S'il Apparaît
    Vérifier Le Contenu Actif Correspond    0     Nantes         A star is born !                  ${Extrait_infos_Nantes}
    Vérifier Le Contenu Actif Correspond    1     Niort          Up to you !                       ${Extrait_infos_Niort}
    Vérifier Le Contenu Actif Correspond    2     Montpellier    Pink is the new black !           ${Extrait_infos_Montpellier}
    Vérifier Le Contenu Actif Correspond    3     Rennes         BZH happy team !                  ${Extrait_infos_Rennes}  
    Vérifier Le Contenu Actif Correspond    4     Toulouse       Pink touch in the pink city !     ${Extrait_infos_Toulouse} 
    Vérifier Le Contenu Actif Correspond    5     Paris          I love Paris !                    ${Extrait_infos_Paris}
    Vérifier Le Contenu Actif Correspond    6     Bordeaux       Let’s work together !             ${Extrait_infos_Bordeaux}
    Vérifier Le Contenu Actif Correspond    7     Lyon           Call to action !                  ${Extrait_infos_Lyon} 
    Vérifier Le Contenu Actif Correspond    8     Strasbourg     Bretzel Forever !                 ${Extrait_infos_Strasbourg}  




Vérifier Le Contenu Actif Correspond
    [Arguments]    ${index}   ${Ville}   ${Titre}   ${Commentaire} 
    Log      Déclaration de variables 
    ${path}=    Set Variable    //div[contains(@class, 'content') and @data-index='${index}']
    ${Détail_Bloc_histo}=    Set Variable    //div[contains(@class, 'text-content')]
    ${Ville_Bloc_histo}=     Set Variable    //div[contains(@class, 'text-content')]/h3[contains(@class, 'head-phrase') and text()='${Ville}']
    ${Titre_Bloc_histo}=     Set Variable    //div[contains(@class, 'text-content')]/h2[contains(@class, 'wp-block-heading') and normalize-space(text())='${Titre}']  
    ${Paragraphe_Bloc_histo}=    Set Variable    //div[contains(@class, 'text-content')]/p[contains(normalize-space(.), '${Commentaire}')]
    
    Log      Actions scroll jusqu'à voir le texte attendurobotframework 
    Wait Until Element Is Visible    ${path}    timeout=5s
    Scroll Element Into View     xpath=${path}
    Wait Until Keyword Succeeds    2 x    2 s    Click Element    xpath=${path}
    Scroll Element Into View     xpath=${Agencies_block_histo}
    Wait Until Keyword Succeeds    2 x    2 s    Press Keys    xpath=//body    ARROW_UP
    # Scroll Element Into View    xpath=${Titre_Bloc_histo}
    # Wait Until Element Is Visible    xpath=${Titre_Bloc_histo}    timeout=10s

    # Scroll vu element    ${Titre} 
    Log      Récupérationde textes visibles à stacker dans une variable 
    ${Ville_name}=    Get Text    ${Ville_Bloc_histo} 
    ${Titre_name}=    Get Text    //div[contains(@class, 'text-content')]/h2    #${Titre_Bloc_histo}
    ${Texte_name}=    Get Text    //div[contains(@class, 'text-content')]/p    #${Paragraphe_Bloc_histo}

    Log    ➤ Le contenu correspondant à l’item ${index} est visible.
    Log    ✅ Ville : ${Ville_name} | Titre : ${Titre_name} | Extrait paragraphe : ${Commentaire}
    Log    📝 Extrait du commentaire trouvé : ${Texte_name}


Activer Tous Les Éléments Et Vérifier Contenu
    FOR    ${index}    IN RANGE    0    9
        Log    ➤ Test de l’item index=${index}
        # Activer L'Élément Par Index    ${index}
        # Vérifier Le Contenu Actif Correspond    ${index}
        Vérification De Toutes Les Agences
        Sleep    0.5s
    END



Selectionner agence par index
    [Arguments]    ${index}
    Run Keyword If      '${index}' == 'Nantes'           Vérifier Le Contenu Actif Correspond    0     Nantes         A star is born !                  ${Extrait_infos_Nantes}
    Run Keyword If      '${index}' == 'Niort'            Vérifier Le Contenu Actif Correspond    1     Niort          Up to you !                       ${Extrait_infos_Niort}
    Run Keyword If      '${index}' == 'Montpellier'      Vérifier Le Contenu Actif Correspond    2     Montpellier    Pink is the new black !           ${Extrait_infos_Montpellier}
    Run Keyword If      '${index}' == 'Rennes'           Vérifier Le Contenu Actif Correspond    3     Rennes         BZH happy team !                  ${Extrait_infos_Rennes}
    Run Keyword If      '${index}' == 'Toulouse'         Vérifier Le Contenu Actif Correspond    4     Toulouse       Pink touch in the pink city !     ${Extrait_infos_Toulouse} 
    Run Keyword If      '${index}' == 'Paris'            Vérifier Le Contenu Actif Correspond    5     Paris          I love Paris !                    ${Extrait_infos_Paris}
    Run Keyword If      '${index}' == 'Bordeaux'         Vérifier Le Contenu Actif Correspond    6     Bordeaux       Let’s work together !             ${Extrait_infos_Bordeaux}
    Run Keyword If      '${index}' == 'Lyon'             Vérifier Le Contenu Actif Correspond    7     Lyon           Call to action !                  ${Extrait_infos_Lyon} 
    Run Keyword If      '${index}' == 'Strasbourg'       Vérifier Le Contenu Actif Correspond    8     Strasbourg     Bretzel Forever !                 ${Extrait_infos_Strasbourg}
    Run Keyword If      '${index}' == 'Toutes'           Vérification De Toutes Les Agences
   


    
    
      
    
    
    
    
    



Scroll vu element 
    [Arguments]    ${texte}
    Wait Until Page Contains Element    xpath=//*[contains(text(), "${texte}")]    timeout=10s
    Scroll Element Into View            xpath=//*[contains(text(), "${texte}")]

Tester Tous Les Indicateurs 
    Activer Tous Les Éléments Un Par Un

Tester Un Élément Aléatoire
    Activer Un Élément Aléatoire

Activer Un Élément Aléatoire
    ${index}=    Evaluate    random.randint(0, 8)    modules=random
    Log    ➤ Index choisi aléatoirement : ${index}
    Activer L'Élément Par Index    ${index}


Activer Tous Les Éléments Un Par Un
    FOR    ${index}    IN RANGE    0    9
        Log    ➤ Activation de l'item index=${index}
        Activer L'Élément Par Index    ${index}
        Sleep    0.5s
    END



Verif des 5 ilots
    Ilot verif dynamique   Infra    97    ${Ilots_Texte_Infra}
    Ilot verif dynamique   AgenceWeb    98    ${Ilots_Texte_AgenceWeb} 
    Ilot verif dynamique   CultureAgile    96    ${Ilots_Texte_CultureAgile} 
    Ilot verif dynamique   Devops    95    ${Ilots_Texte_Devops} 
    Ilot verif dynamique   Dev    94   ${Ilots_Texte_Dev}



Ilot verif dynamique 
    [Arguments]    ${name}   ${num}   ${text}
    ${element}=    Set Variable    id=tease-${num} 
    ${cle} =    Set Variable    ${name}
    Wait Until Element Is Visible    ${Accueil_Ilots_container}    10
    Scroll Element Into View     ${Accueil_Ilots_container}  
    ${texte}=    Get Text    ${element}
    ${nom_variable}=    Catenate    SEPARATOR=    Texte_    ${cle}
    Set To Dictionary    ${TEXTES_PAR_ILOT}    ${nom_variable}=${texte} 
    Element Text Should Be    ${element}    ${text} 



Verif agences 
    [Arguments]    ${xpath}   ${text} 
    Wait Until Element Is Visible    ${xpath}    10
    Element Should Be Visible    ${xpath}
    Scroll Element Into View     ${xpath}  
    ${texte}=    Get Text    ${xpath} 
    Capture Element Et Sauvegarde  ${xpath}  Screenshot  capture_agences_accueil
    Element Text Should Be    ${xpath}    ${text}



Actu agences 
    [Arguments]    ${xpath}   #${text} 
    Wait Until Element Is Visible    ${xpath}    10
    Element Should Be Visible    ${xpath}
    Scroll Element Into View     ${xpath}  
    ${texte}=    Get Text    ${xpath} 
    Capture Element Et Sauvegarde  ${xpath}  Screenshot  capture_actu_agences
    # Element Text Should Be    ${xpath}    ${text}

    



Vérifier logo
    [Arguments]    ${xpath_logo}
    Wait Until Element Is Visible    ${xpath_logo}    10
    Page Should Contain Element    ${xpath_logo}
    Capture Element Et Sauvegarde      ${xpath_logo}    Screenshot   logo 
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${xpath_logo}            


Verifier Titre Visible  
    [Arguments]    ${xpath}    ${texte_attendu}
    Log    méthode réutilisable pour vérifier un texte : 
    Wait Until Element Is Visible    ${xpath}    10
    Element Text Should Be           ${xpath}    ${texte_attendu}   
    Sleep  0.5s
    Log    Extraire et tester dynamiquement : 
    # ${titre}=    Get Text    xpath=${postech}
    ${titre}=    Get Text    ${xpath}
  



Verif elements ilots
    # [Arguments]    ${xpath}
    # Wait Until Element Is Visible    ${xpath}    10
    # Wait Until Keyword Succeeds    2 x    2 s    Click Element     ${xpath}  
    # # # Wait Until Keyword Succeeds    2 x    2 s    Vérifier quelques mots avec une boucle 
    # # Action Scroll   ${footer}      
    # # Capture Page Et Sauvegarde     Screenshot   capture_footer

    Wait Until Element Is Visible    //div[contains(@class, "ilots-container")]//a[contains(@href, "/infra-cloud") and contains(normalize-space(.), "Infra")]    10
    Wait Until Keyword Succeeds    2 x    2 s    Click Element    //div[contains(@class, "ilots-container")]//a[contains(@href, "/infra-cloud") and contains(normalize-space(.), "Infra")]
    Capture Page Screenshot

 

Cliquer sur un lien ilots   
    [Arguments]    ${nom}
    ${xpath}=    Set Variable    //div[contains(@class, "ilots-container")]//a[contains(., "${nom}")]
    Scroll Element Into View     ${xpath}
    Wait Until Element Is Visible    ${xpath}    10
    Wait Until Keyword Succeeds    2 x    2 s    Click Element    ${xpath}



Actions Ilots   
    [Arguments]    ${xpath}    ${FILE_OUTPUT}
    Wait Until Element Is Visible    ${xpath}    10
    Scroll Element Into View     ${xpath}
    Wait Until Element Is Visible    ${xpath}    10
    Wait Until Keyword Succeeds    2 x    2 s    Click Element    ${xpath}
    Log    Vérifier que l’image est bien présente dans le DOM (même si invisible)
    Page Should Contain Element       ${Xpath_IMG}
    Suite verif     ${Xpath_IMG}     ${FILE_OUTPUT}
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Conserto}


Test actions Ilots
    Log     vérif présences et comportements des ilots - téléchargement images des ilots  
    Actions Ilots    ${Ilots_Infra}               ${FILE1_OUTPUT_Infra}
    Actions Ilots    ${Ilots_Devops}              ${FILE2_OUTPUT_Devops}
    Actions Ilots    ${Ilots_Dev}                 ${FILE3_OUTPUT_Dev}
    Actions Ilots    ${Ilots_Agence_Web}          ${FILE4_OUTPUT_Agence_Web}
    Actions Ilots    ${Ilots_Culture_Agile}       ${FILE5_OUTPUT_Culture_Agile}


Suite verif     
    [Arguments]    ${xpath}    ${FILE_OUTPUT}
    # Vérifier que l’image est bien présente dans le DOM (même si invisible)
    Page Should Contain Element    ${xpath}

    # # Vérifier les titres
    # Element Text Should Be    xpath=${H1_XPATH}    ${EXPECTED_H1}
    # Element Text Should Be    xpath=${B_XPATH}     ${EXPECTED_B}

    # Récupérer l’attribut src (ou fallback sur data-src si lazy loading)
    ${src}=    Get Element Attribute    xpath=${xpath}    src
    Run Keyword If    '${src}' == '' or '${src}' == None
    ...    ${src}=    Get Element Attribute    xpath=${xpath}    data-src

    Should Not Be Empty    ${src}
    Log    Image src: ${src}

    # Construire l’URL absolue si besoin (ne concatène que si URL relative)
    ${is_absolute}=    Evaluate    "'${src}'.startswith('http')"
    Run Keyword If    not ${is_absolute}    Set Variable    ${src}    ${URL_CONSERTO}${src}   #${BASE_URL}${src}
    Log    Image URL final: ${src}

    ${parsed}=    Evaluate    __import__('urllib.parse', fromlist=['urlparse']).urlparse('${src}')
    ${base_url}=  Set Variable    ${parsed.scheme}://${parsed.netloc}
    ${path}=      Set Variable    ${parsed.path}${parsed.params}${parsed.query}${parsed.fragment}

    Log    Base URL: ${base_url}
    Log    Path: ${path}

    # Télécharger l'image
    Create Session    img_dl    ${base_url}
    ${response}=    GET On Session    img_dl    ${path}
    Should Be Equal As Integers    ${response.status_code}    200

    Create Binary File    ${FILE_OUTPUT}    ${response.content}
    File Should Exist    ${FILE_OUTPUT}
    Déplacer Plusieurs Fichiers



    Log    Download Image
    # Create Session    img_dl    ${BASE_URL}
    # ${response}=    GET On Session    img_dl    ${path}   #${IMG_PATH}
    # Save Response To File    ${response}    ${FILE_OUTPUT}   # ${LOCAL_FILE}
    # Log    Image saved to ${FILE_OUTPUT}    # ${LOCAL_FILE}



    ######

    # Create Session    img_dl    ${BASE_URL}
    # ${response}=    GET On Session    img_dl    ${path}
    # Log               Status Code: ${response.status_code}
    # Should Be Equal As Integers    ${response.status_code}    200
    # ${image_bytes}=   Set Variable    ${response.content}
    # # Create File       ${FILE_OUTPUT}    ${image_bytes}    binary=True
    # # Log               Image saved as ${FILE_OUTPUT}
    # Write Binary File    ${FILE_OUTPUT}    ${image_bytes}
    # Log    Image saved to ${FILE_OUTPUT}


    # Create Session    img_dl    ${BASE_URL}
    # ${response}=    GET On Session    img_dl    ${path}
    # Should Be Equal As Integers    ${response.status_code}    200
    # ${image_bytes}=   Set Variable    ${response.content}
    # Evaluate          open("${FILE_OUTPUT}", "wb").write(${image_bytes})    modules=os
    # Log               Image saved to ${FILE_OUTPUT}


Déplacer Plusieurs Fichiers
    # ${fichiers}=    List Files In Directory    ${DOSSIER_PROJET}    pattern=downloaded_image*
    ${fichiers}=    List Files In Directory    ${EXECDIR}    pattern=downloaded_image*
    FOR    ${fichier}    IN    @{fichiers}
        Move File    ${EXECDIR}/${fichier}    ${SCREENSH_DIR}/${fichier}
        Log    ➡️ Déplacé : ${fichier}
    END



Save Response To File
    [Arguments]    ${response}    ${file_path}
    ${content}=    Get Binary Content From Response    ${response}
    Write Binary File    ${file_path}    ${content}





Vérifier quelques mots avec une boucle
    ${html}=    Get Source
    FOR    ${mot}    IN    @{mots_attendus}
        Should Contain    ${html}    ${mot}
        ${log}=    Set Variable    ${mot}
        Log    ${log}
        Log to console      ${log}  
    END



Action Scroll   
    [Arguments]     ${element} 
    Wait Until Keyword Succeeds    2 x    2 s        Wait Until Element Is Visible   ${element}        60
    Scroll Element Into View    ${element} 


Remonter en haut
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    2s
    Capture Page Screenshot


Nettoyage captures
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures Selenium



Nettoyer Dossier Logs
    [Arguments]    ${destination}=Logs
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures Selenium

    
Supprimer Captures Selenium
    ${captures}=    List Files In Directory    ${OUTPUTDIR}    selenium-screenshot-*.png
    FOR    ${f}    IN    @{captures}
        Remove File    ${OUTPUTDIR}/${f}
    END

Nettoyer Dossier Resultats
    [Arguments]    ${destination}=Resultats
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures Resultats

Supprimer Captures Resultats
    ${captures}=    List Files In Directory    ${OUTPUTDIR}    selenium-element-screenshot-*.png
    FOR    ${f}    IN    @{captures}
        Remove File    ${OUTPUTDIR}/${f}
    END


Nettoyer les captures
    [Arguments]    ${destination}=Conserto-1 
    Create Directory    ${destination}
    # Move File    output.xml    ${destination}/output.xml
    # Move File    log.html      ${destination}/log.html
    # Move File    report.html   ${destination}/report.html
    Supprimer Captures dossier mere 

Supprimer Captures dossier mere 
    ${captures}=    List Files In Directory    ${OUTPUTDIR}    selenium-element-screenshot-*.png
    FOR    ${f}    IN    @{captures}
        Remove File    ${OUTPUTDIR}/${f}
    END



Test navigation fonctionne
    Element Barre de nav   ${Positive}    POSITIVE      capture_page_positive     ${FICHIER_REF_POSITIVE}
    # Générer Fichier De Référence      ${FICHIER_REF_POSITIVE}  
    Element Barre de nav   ${Technologie}   TECHNOLOGIE    capture_page_technologie     ${FICHIER_REF_TECHO}  
    Element Barre de nav   ${Clients}       NOS CLIENTS    capture_page_clients     ${FICHIER_REF_CLIENTS}   
    Element Barre de nav   ${Academy}       ACADEMY        capture_page_academy     ${FICHIER_REF_ACADEMY}   
    Element Barre de nav sans   ${Blog}     BLOG           capture_page_blog        ${FICHIER_REF_BLOG}     
    Element Barre de nav sans   ${Contact}    CONTACT      capture_page_contact     ${FICHIER_REF_CONTACT}       
    # Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Conserto}
    Renseigner les infos contact    ALATA     Alpha     alpha.alata@conserto.pro    Niort    Candidature     ${VotreMessage}    Non


Verif navigation element par element   
    Barre de nav positive
    Barre de nav Technologie
    Barre de nav Clients 
    Barre de nav Academy
    Barre de nav Blog
    Barre de nav Contact


Action Barre de navigation
    Log     Action 1 - Vérifier la présence et contenu de la barre de navigation 
    Barre du menu navigation 
    Log     Action 2 - Vérif elements du header, générer et comparer les Fichiers de référence
    Test navigation fonctionne



Barre du menu navigation 
    # [Arguments]    ${texte} 
    ${Action_1}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${Mobile_menu}       10  
    ${Action_2}=      Run Keyword And Return Status    Wait Until Page Contains    ${Posit_texte}    10  
    ${Action_3}=      Run Keyword And Return Status    Wait Until Element Is Visible    ${Barre_de_nav}      10
    # ${Action_3}=      Run Keyword And Return Status    Wait Until Keyword Succeeds	    5s	3s    Wait Until Element Is Visible    ${Mobile_menu}      
    # Run Keyword If    ${Action_1}    Barre de Navigation    
    # ...    ELSE IF    ${Action_2}    Verif Elements bloc nav
    # ...    ELSE IF    ${Action_3}    Barre mobile nav    

    Run Keyword If    ${Action_1}    Barre mobile nav         
    ...    ELSE IF    ${Action_2}    Barre de Navigation 
    ...    ELSE IF    ${Action_3}    Verif Elements bloc nav
    

    # IF  '${texte}'=='***'      
    #     Log    Aucune requête exécutée. 
    # END


Values nav 
    [Arguments]    ${texte}
    ${status}    Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10  
    
    IF    ${status}
        Log    On constate bien que "${texte}" est bien visible.
        Verif Elements bloc nav
    ELSE
        Log    "${texte}" non trouvé. Tentative de chargement de la barre de navigation.    WARN
        Run Keyword    Barre de Navigation
        # Wait Until Page Contains    ${texte}    10
        ${status2}    Run Keyword And Return Status    Wait Until Page Contains    ${texte}    10

            IF    ${status2}
                Log    "${texte}" affiché après chargement de la barre de navigation.
                Run Keyword    Barre mobile nav    
            ELSE
                Log    "${texte}" toujours non visible. Tentative via barre mobile.    WARN
                Run Keyword    Verif Elements bloc nav
            END
    END



Values nav2  
    [Arguments]    ${xpath}   ${xpath2}
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    ${xpath}       10 
    
    IF    ${status}
        Log    On constate bien que "${xpath}" est bien visible.
        Verif Elements bloc nav
    ELSE
        Log    "${xpath}" non trouvé. Tentative de chargement de la barre de navigation.    WARN
        # Run Keyword    Barre de Navigation
        Run Keyword    Barre mobile nav    
        # Wait Until Page Contains    ${texte}    10
        ${status2}    Run Keyword And Return Status    Wait Until Element Is Visible    ${xpath2}    10

            IF    ${status2}
                Log    "${xpath2}" affiché après chargement de la barre de navigation.
                Run Keyword    Barre mobile nav    
            ELSE
                Log    "${xpath2}" toujours non visible. Tentative via barre mobile.    WARN
                Run Keyword    Barre de Navigation
            END
    END



Barre de Navigation
    ${status}    Run Keyword And Return Status    Element Should Be Visible      ${Barre_de_nav} 
    IF     ${status}
        Log    On constate bien que "${Barre_de_nav}" est bien visible.
        Run Keyword    Nav mode global hors mobile
    ELSE   
        Log    "${Barre_de_nav}" non trouvé. Tentative de chargement de la barre de navigation.    WARN
        Run Keyword    Nav mode global avec mobile
    END


Nav mode global hors mobile 
    # Set Window Size    1280    1024
    # Maximize Browser Window
    # Maximize Brows
    Log   methode 1 :
    Log   Vérifier que l'élément est visible dans le navigateur :
    Wait Until Element Is Visible    ${Barre_de_nav}      timeout=20s
    Wait Until Keyword Succeeds	    5s	3s      Element Should Be Visible        ${Barre_de_nav}
    Log   Vérifier que l’attribut HTML d’un élément contient exactement les valeurs attendues : 
    Element Attribute Value Should Be    ${Barre_de_nav}    class    nav-main

    Log     Vérification du contenu dynamique : vérifier que le texte d’un élément contient une sous-chaîne spécifique
    Element Should Contain    ${Barre_de_nav}     ${Nav_texte}
    Page Should Contain Element    ${Barre_de_nav}
    Wait For Condition    return document.readyState === 'complete'    timeout=15s
    ${nav_value} =   Get Text    ${Barre_de_nav}
    Log    Valeur récupérée : ${nav_value}
    Log to console    ${nav_value}   

    Log   methode 2 :
    Log     Vérifier qu'un certain texte est présent quelque part dans la page HTML visible : 
    Wait Until Element Is Visible    xpath=//*[@id="nav-main"]    timeout=15s
    Page Should Contain    Positive
    # Run Keyword And Ignore Error    Capture Page Screenshot
    Capture Page Et Sauvegarde     Screenshot   capture_Positive_Techno
    
    Log   methode 3 :
    Log   Screenshot capturé pour analyse et récupérer la valeur d’un attribut HTML
    ${html} =    Get Element Attribute    ${Barre_de_nav}    innerHTML
    Log    Contenu HTML : ${html} 


    # Log   methode 1
    # Wait Until Element Is Visible    ${Barre_de_nav}    timeout=20s
    # Page Should Contain Element    ${Barre_de_nav}
    # Wait For Condition    return document.readyState === 'complete'    timeout=15s
    
    # Log   methode 2
    # # Wait For Condition    return document.readyState === 'complete'    timeout=20s
    # Wait Until Element Is Visible    xpath=//*[@id="nav-main"]    timeout=15s
    # Page Should Contain    Positive
    # Run Keyword And Ignore Error    Capture Page Screenshot

    # Log   methode 3
    # Wait Until Element Is Visible    ${Barre_de_nav}    timeout=10s
    # ${nav_value} =   Get Text    ${Barre_de_nav}
    # Log    Valeur récupérée : ${nav_value}
    # Page Should Contain Element    ${Barre_de_nav}
    # Run Keyword And Ignore Error    Capture Page Screenshot

    # Log   methode 4 : Screenshot capturée pour analyse
    # ${html} =    Get Element Attribute    ${Barre_de_nav}    innerHTML
    # Log    Contenu HTML : ${html}

     
Nav mode global avec mobile
    Log   methode mobile
    Wait Until Element Is Visible    ${Mobile_menu}    timeout=10s
    ${nav_value} =   Get Text    ${Mobile_menu}
    Log    Valeur récupérée : ${nav_value}
    Page Should Contain Element    ${Mobile_menu}
    # Run Keyword And Ignore Error    Capture Page Screenshot
    Capture Page Et Sauvegarde     Screenshot   capture_menu_mobile
    Log    Screenshot capturée pour analyse 

    Log   methode 
    ${html} =    Get Element Attribute    ${Barre_de_nav}    innerHTML
    Log    Contenu HTML : ${html}   
    

Barre mobile nav
    # [Arguments]    ${texte}
    Wait Until Element Is Visible    ${Mobile_menu}      timeout=15s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Mobile_menu}
    Capture Page Et Sauvegarde     Screenshot   capture_mobile
    # Run Keyword And Ignore Error    Capture Page Screenshot

    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]      timeout=15s
    Capture Page Et Sauvegarde     Screenshot   capture_nav_mobile
    # Run Keyword And Ignore Error    Capture Page Screenshot
    
    Log    verif 1
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a      timeout=15s
    ${texte_nav} =    Get Text    xpath=//nav[@id="nav-main"]//a
    Log    Liens de navigation : ${texte_nav}

    Log    verif 2
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a[text()="Accueil"]      timeout=15s
    ${accueil} =    Get Text    xpath=//nav[@id="nav-main"]//a[text()="Accueil"]
    Log    Texte Accueil : ${accueil}

    Log    verif 3
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]    timeout=10s
    Page Should Contain Element      xpath=//nav[@id="nav-main"]
    ${contenu} =    Get Text         xpath=//nav[@id="nav-main"]
    Log    Contenu nav-main : ${contenu}

    Log    verif 4
    ${html} =    Get Element Attribute    xpath=//nav[@id="nav-main"]    innerHTML
    Log    Contenu HTML de nav-main : ${html}

    Log    verif 5 : Récupérer chaque lien un par un
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a      timeout=15s
    ${link1} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[1]
    ${link2} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[2]
    ${link3} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[3]
    ${link4} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[4]
    ${link5} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[5]
    ${link6} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[6]
    ${link7} =    Get Text    xpath=(//nav[@id="nav-main"]//a)[7]

    # Log    verif 5 : Récupérer tous les liens comme une liste (avec Get WebElements) 
    # @{links} =    Get WebElements    xpath=//nav[@id="nav-main"]//a
    # :FOR    ${el}    IN    @{links}
    # \    ${txt}=    Get Text    ${el}
    # \    Log    Lien : ${txt}

    Log    verif 6 : Recommandation 
    Wait Until Element Is Visible    xpath=//nav[@id="nav-main"]//a[contains(text(), "Accueil")]

    

    

Culture agile cas 2
    # Maximize Brows
    Barre de Navigation
    Wait Until Element Is Visible    ${Positive}      timeout=15s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Positive} 
    Element Should Contain     //div    ${Texte_Positive}
    Element Text Should Be    ${Textes_complets_Positive}    ${Texte_Positive}
    Page Should Contain       ${Texte_Positive}
    Action Scroll   ${footer}
    Controle historique conserto
    Remonter en haut
    # Maximize Brows



Culture agile
    Wait Until Element Is Visible    ${Culture_Agile}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Culture_Agile} 

Controle historique conserto
    Wait Until Element Is Visible    ${historique}      timeout=15s
    Wait Until Element Is Visible    ${histo}      timeout=15s
    Wait Until Element Is Visible    ${annees_2013}      timeout=15s
    Page Should Contain       2013
    Wait Until Keyword Succeeds	    5s	3s      Cliquer sur le numero annee    2013    0 
 
    

Cliquer sur le numero annee
    [Arguments]    ${annee}    ${index} 
    Log    Déclaration de variables :  
    ${xpath}=    Set Variable    ${histo}//div[text()="${annee}"]
    ${xpath_element1}=    Set Variable    //div[@class="slider-item" and @data-index="${index}"] 
    ${xpath_element2}=    Set Variable    div/div[2]/div[@class='timeline-item__content'] 
    ${xpath_infos}=    Set Variable    ${xpath_element1}/${xpath_element2}
    Log    Pointer sur l'année : 
    Scroll Element Into View    xpath=${xpath}
    Wait Until Keyword Succeeds	    5s	3s      Click Element     xpath=${xpath}
    Log    Infos elements pointé : 
    Wait Until Element Is Visible    xpath=${xpath_infos}      10
    ${2013_value}=    Get text    ${xpath_infos}
    Sleep    3s
    Wait Until Keyword Succeeds	    5s	3s    Capture Element Screenshot    ${xpath_infos}

Info annee 2013
    [Arguments]    ${index}
    # ${xpath}=    Set Variable    (//*[text()="2013"])[${index}]  
    ${xpath_element1}=    Set Variable    //div[@class="slider-item" and @data-index="${index}"] 
    ${xpath_element2}=    Set Variable    div/div[2]/div[@class='timeline-item__content'] 
    ${xpath_infos}=    Set Variable    ${xpath_element1}/${xpath_element2}    #//div[@class="slider-item" and @data-index="${index}"]/div/div[2]/div[@class='timeline-item__content'] 
    Wait Until Element Is Visible    xpath=${xpath_infos}      10
    Wait Until Keyword Succeeds	    5s	3s    Capture Element Screenshot    ${xpath_infos}
    # Wait Until Element Is Visible    ${Info_2013}      60
    # Capture Element Screenshot    ${Info_2013}


 




Element Barre de nav
    [Arguments]    ${xpath}   ${element}     ${image_name}    ${name_file}
    Log    Verif élément "${element}" dans le header :
    Wait Until Element Is Visible    ${xpath}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${xpath}
    Capture Page Et Sauvegarde     Screenshot   ${image_name}
    Action Scroll   ${footer}
    # Action Scroll   ${Barre_de_nav}
    # Scoller bas vers haut
    Générer Fichier De Référence     ${name_file}



Générer Fichier De Référence
    [Arguments]    ${name_file}        
    Wait Until Page Contains Element    xpath=//body    15s
    ${texte_page}=    Get Text    xpath=//body
    Log   Étape 1 : Créer le fichier dans le dossier mère
    Create File    ${name_file}    ${texte_page}
    Log   Étape 2 : Vérifier et comparer les fichiers  
    Vérifier Texte Complet De La Page    ${name_file}
    # Move Directory    ${source_dossier}    ${destination}
    Log   Étape : Déplacer le fichier dans Pages
    Move File    ${name_file}    ${EXECDIR}/Pages/${name_file} 



 



Vérifier Texte Complet De La Page
    [Arguments]    ${name_file}
    Wait Until Page Contains Element    xpath=//body    15s
    ${texte_page} =    Get Text    xpath=//body
    ${texte_reference} =    Get File     ${name_file}
    # Log     1ere methode : mévif simple
    # Should Be Equal    ${texte_page}    ${texte_reference}    msg=Le texte de la page a changé !
    Log     2ème methode : mévif et remonte mot différent :
    ${set1}=    Evaluate    set("""${texte_page}""".split())
    ${set2}=    Evaluate    set("""${texte_reference}""".split())
    ${diff}=    Evaluate    sorted(${set1}.symmetric_difference(${set2}))
    Log    Mots différents: ${diff}
    Should Be Empty    ${diff}    msg=Des différences ont été détectées: ${diff}



Comparer Texte Lignes
    ${texte_page}=       Get Text    xpath=//body
    ${texte_reference}=  Get File    ${FICHIER_REFERENCE}
    ${diff}=    differences_lignes    ${texte_page}    ${texte_reference}
    Run Keyword If    '${diff}' != 'Aucune différence détectée.'    Fail    ${diff}
    

Test Comparaison
    ${t1}=    Set Variable    Ceci est une version de la page
    ${t2}=    Set Variable    Ceci est la version actuelle de la page
    ${diff}=    Mots Differents    ${t1}    ${t2}
    Log    ${diff}
    Run Keyword If    '${diff}' != 'Aucune différence détectée.'    Fail    ${diff}



    
Element Barre de nav sans
    [Arguments]    ${xpath}   ${element}     ${image_name}   ${name_file}
    Log    Verif élément "${element}" dans le header :
    Wait Until Element Is Visible    ${xpath}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${xpath}
    Capture Page Et Sauvegarde     Screenshot   ${image_name}
    # Action Scroll   ${footer}
    # Action Scroll   ${Barre_de_nav}
    # Scoller bas vers haut
    Générer Fichier De Référence     ${name_file}


Scoller bas vers haut 
    Log To Console    🔽 Scrolling vers le bas...
    Wait Until Keyword Succeeds	    5s	3s   Execute Javascript    window.scrollTo(0, document.body.scrollHeight)
    Sleep     2s 
    Log To Console    🔼 Scrolling vers le haut...
    Wait Until Keyword Succeeds	    5s	3s   Execute Javascript    window.scrollTo(0, 0)


Verif ilots
    [Arguments]    ${xpath}
    Wait Until Element Is Visible    ${xpath}    10
    Wait Until Keyword Succeeds    2 x    2 s    Click Element     ${xpath}  
    # Wait Until Keyword Succeeds    2 x    2 s    Vérifier quelques mots avec une boucle 
    Action Scroll   ${footer}      
    Capture Page Et Sauvegarde     Screenshot   capture_footer



Renseigner les infos contact 
    [Arguments]     ${Nom}   ${Prenom}   ${Email}   ${Agence}    ${contact}    ${message}    ${Operation}
    Page Should Contain    Nous contacter
    Element Should Contain    ${Title_bloc_contact}    Nous contacter
    Capture Element Et Sauvegarde    ${Bloc_contact}    Screenshot     capture_champs_contact
    Saisir Champs contact     ${Nom}   ${Prenom}   ${Email}   ${Agence}    ${contact}    ${message}    ${Operation}
    Capture Page Screenshot



Saisir Champs contact 
    [Arguments]    ${Nom}   ${Prenom}   ${Email}   ${Agence}    ${contact}    ${message}    ${Operation}
    Wait Until Element Is Visible                     ${Bloc_contact}      60
    Saisir champ    ${Nom_Bloc_contact}               ${Nom} 
    Saisir champ    ${Prénom_Bloc_contact}            ${Prenom}
    Saisir champ    ${Email_Bloc_contact}             ${Email}
    Champ à renseigner     ${Champ_Agence}            ${Agence}
    Champ à renseigner     ${Champ_contact}           ${contact}
    Message à envoyer      ${Champ_saisi_Message}     ${message}
    Uploader Requirements Txt    ${Button_Envoyer_Message}       ${CHEMIN_FICHIER}   
    Cocher Checkbox    ${Checkbox_contact}
    Actions button envoyer message     ${Operation}




Actions button envoyer message  
    [Arguments]     ${Operation}
    Wait Until Element Is Visible       ${Button_Envoyer_Message}        60 
    Run Keyword If      '${Operation}' == 'Non'       Alerte personnalisee  
    Run Keyword If      '${Operation}' == 'Oui'       Double Click Element        ${Button_Envoyer_Message}



Alerte personnalisee 
    Log    ===============================⛔ ALERTE CRITIQUE ⛔ ===============================
    ...    WARN
    Log    ATTENTION : Le bouton "Envoyer le message" ne doit pas être utilisé dans ce contexte. \nCela pourrait entraîner un envoi automatique d'emails indésirables à l'agence.  WARN
    # Log    Attention : Le bouton "Envoyer le message" ne doit pas être utilisé dans ce contexte. 
    # Log    Cela pourrait entraîner un envoi automatique d'emails indésirables à l'agence.    
    ...    WARN
    Log    =====================================================================================
    ...    WARN








Saisir champ    
    [Arguments]     ${Xpath}   ${Nom}
    Wait Until Element Is Visible       ${Xpath}      60
    Wait Until Keyword Succeeds    2 x    2 s     Clear Element Text        ${Xpath}
    Wait Until Keyword Succeeds    2 x    2 s     Click Element             ${Xpath}
    # Wait Until Keyword Succeeds    10 x    2 s     Input Field            ${Nom_Bloc_contact}   ${Nom}  
    Wait Until Keyword Succeeds    10 x    2 s     Input Text               ${Xpath}   ${Nom}
    # Press Keys    None    ENTER
    Wait Until Keyword Succeeds	    5s	5s    Press Keys  None  TAB
    Wait Until Keyword Succeeds	    5s	5s    Press Keys       ${Xpath}        TAB 
    # # Press Keys    ${Saisie_JJD_Nora}    ${Num1}
    # Wait Until Keyword Succeeds    10 x    2 s     Click Element                       ${Click_Nom_Prenom_Soc}




Champ à renseigner     
    [Arguments]     ${Xpath}   ${element}
    Wait Until Element Is Visible       ${Xpath}      60
    ${Liste}=    Get List Items    ${Xpath}
    
    Log     méthode 1 : 
    Log List    ${Liste}
    Should Contain    ${Liste}    ${element}
    Select From List By Label    ${Xpath}   ${element}   

    Log     méthode 2 :
    # ${Liste}=    Get List Items    ${Xpath}
    Run Keyword If    '${element}' in ${Liste}
    ...    Select From List By Label    ${Xpath}    ${element}
    ...  ELSE
    ...    Log To Console    🚨 '${element}' n’est pas dans la liste des agences !
    ...    Log    '${element}' absente de la liste d’agences : ${Liste}    WARN
    ...    Capture Page Screenshot

    # Wait Until Keyword Succeeds	    5s	5s    Press Keys  None  TAB
    # Wait Until Keyword Succeeds	    5s	5s    Press Keys       ${Xpath}        TAB
    # Sleep      5s 



Message à envoyer 
    [Arguments]     ${Xpath}   ${message}
    Wait Until Element Is Visible       ${Xpath}      60
    Log      1ère méthode : Lire Message Et Le Coller Dans Un Champ. 
    Lire Message Et Le Coller Dans Un Champ    ${Xpath}

    Log      2ème méthode : saisir le message dans un champ.
    Écrire le message à envoyer     ${Xpath}   ${message} 
     
    Log    Vérif du après saisie du message :
    ${valeur}=    Get Value    ${Xpath}
    Should Be Equal    ${valeur}    ${message} 
    Log    Texte saisi : ${message}



Uploader Requirements Txt    
    [Arguments]     ${Xpath}    ${emplacement}  
    Wait Until Element Is Visible    ${Xpath}      20
    Scroll Element Into View    ${Xpath}
    Téléverser Fichier      ${emplacement}    



Téléverser Fichier  
    [Arguments]     ${emplacement}
    Log     Injecte le fichier dans le champ caché
    Execute Javascript
    ...    const input = document.querySelector('input[type="file"]');
    ...    input.style.display = 'block';

    Log     Sélectionne le fichier
    Choose File    xpath=//input[@type="file"]    ${emplacement} 

    Log     Re-cacher le champ si besoin (optionnel)
    Execute Javascript
    ...    const input = document.querySelector('input[type="file"]');
    ...    input.style.display = 'none';

    
Cocher Checkbox
    [Arguments]     ${xpath}
    Wait Until Element Is Visible    ${xpath}      60
    ${is_checked}=    Get Element Attribute    ${xpath}    checked
    # Run Keyword Unless    '${is_checked}'=='true'    Wait Until Keyword Succeeds    3 x    2 s    Click Element    ${xpath}
    IF    '${is_checked}' != 'true'
        Wait Until Keyword Succeeds    3 x    2 s    Click Element    ${xpath}
    END


Écrire le message à envoyer
    [Arguments]     ${Xpath}   ${message}
    Log     Saisir le message à envoyer : 
    Wait Until Keyword Succeeds    2 x    2 s     Clear Element Text        ${Xpath}
    Wait Until Keyword Succeeds    2 x    2 s     Click Element             ${Xpath}
    # Wait Until Keyword Succeeds    10 x    2 s     Input Field            ${Nom_Bloc_contact}   ${Nom}  
    Wait Until Keyword Succeeds    3 x    2 s     Input Text     ${Xpath}     ${message} 

    Wait Until Keyword Succeeds	    5s	5s    Press Keys  None  TAB
    # Wait Until Keyword Succeeds	    5s	5s    Press Keys       ${Xpath}        TAB


Lire Message Et Le Coller Dans Un Champ
    [Arguments]     ${Xpath}  
    Wait Until Keyword Succeeds    2 x    2 s     Clear Element Text     ${Xpath}
    Wait Until Keyword Succeeds    2 x    2 s     Click Element          ${Xpath}
    ${message}=    Get File    ${CHEMIN_FICHIER}
    Input Text     ${Xpath}    ${message}

Barre de nav positive
    Wait Until Element Is Visible    ${Positive}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Positive}


Barre de nav Technologie
    # Barre de Navigation
    Wait Until Element Is Visible    ${Technologie}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Technologie}


Barre de nav Clients
    Wait Until Element Is Visible    ${Clients}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Clients}


Barre de nav Academy
    Wait Until Element Is Visible    ${Academy}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Academy}


Barre de nav Blog
    Wait Until Element Is Visible    ${Blog}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Blog}


Barre de nav Contact
    Wait Until Element Is Visible    ${Contact}      60
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Contact}



Page d'accueil Idnow 
    [Arguments]     ${Title}  
    # Maximize Brows
    Log  Page Accueil - vérif titre et éléments du menu nav : 
    Verif title Idnow   ${Title}
    # # Verif Elements bloc nav 
    # Conditions menu nav     Positive
    
    # Log  Page Accueil - vérif logo et quelques éléments de la page : 
    # Vérifier logo   ${Conserto}
    # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    # Verif ilots


Barre de Nav Idnow
    [Arguments]     ${xpath}
    Scroll Element Into View    ${xpath}
    Sleep    3s 
    AWait Browser Ready And Complete
    Affichage et actualisation     ${xpath} 
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${xpath}      timeout=30s
    Wait Until Keyword Succeeds	    5s	3s      Click Element    ${xpath}
    Wait Until Keyword Succeeds	    5s	3s      Capture Element Screenshot    ${xpath}

Affichage et actualisation 
    [Arguments]     ${xpath}
    Wait Until Page Contains Element    //body    timeout=10s

    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${xpath}    timeout=60s
    ${visible}=    Run Keyword And Return Status    Element Should Be Visible    ${xpath}

    Run Keyword If    not ${visible}    Reload Page
    Wait Until Element Is Visible    ${xpath}    timeout=60s


Action nav Idnow
    [Arguments]     ${texte}   ${element}
    Wait Until Element Is Visible    xpath=//nav//span[text()='${texte}']
    Mouse Over    xpath=//nav//span[text()='${texte}']
    Wait Until Element Is Visible    xpath=//a//span[text()='${element}']    timeout=5
    Wait Until Keyword Succeeds	    5s	3s   Click Element    xpath=//a//span[text()='${element}']
    Wait Until Keyword Succeeds	    5s	3s   Capture Page Screenshot  

Afficher Tous Les cas 
    [Arguments]     ${service}   @{element}
    ${premier}=    Set Variable    ${element}[0]
    # ${dernier}=    Set Variable    ${element}[-1]
    FOR    ${service}    IN    @{element} 
        Log    élément : ${service}
        Log    Le premier élément est : ${premier}
        Capture Page Screenshot
    END


Fermer Le Popup S'il Apparaît
    Capture Page Screenshot
    ${popup}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class, 'event-popup') and contains(@class, 'visible')]//*[name()='svg'][@class='close-icon']    timeout=10s
    Run Keyword If    ${popup}    Click Element    xpath=//div[contains(@class, 'event-popup') and contains(@class, 'visible')]//*[name()='svg'][@class='close-icon']


    # Execute JavaScript    document.querySelector('div.event-popup.visible svg').click()



Supprimer les fichiers Selenium png    
    [Arguments]     ${Chemin}    ${Chemins}    ${racine} 
    # # ${fichiers}=    List Files In Directory    ${Chemin}    pattern=capture_*
    # ${captures}=    List Files In Directory    ${Chemin}    pattern=capture_*
    # ${logos}=       List Files In Directory    ${Chemin}    pattern=logo
    # ${selenium}=    List Files In Directory    ${Chemin}    pattern=selenium-*
    # ${fichiers}=    Combine Lists    ${captures}    ${logos}    ${selenium}

    # FOR    ${fichier}    IN    @{fichiers}
    #     Remove File    ${Chemin}/${fichier}
    # END
    ${captures1}=    List Files In Directory    ${Chemin}    pattern=capture_*
    ${captures2}=    List Files In Directory    ${Chemin}    pattern=downloaded_image_*
    ${captures}=     Combine Lists    ${captures1}    ${captures2}
    FOR    ${fichier}    IN    @{captures}
        Remove File    ${Chemin}/${fichier}
    END
    # ${captures}=    List Files In Directory    ${Chemin}    pattern=capture_*
    # FOR    ${fichier}    IN    @{captures}
    #     Remove File    ${Chemin}/${fichier}
    # END

    ${logos}=    List Files In Directory    ${Chemin}    pattern=logo*
    FOR    ${fichier}    IN    @{logos}
        Remove File    ${Chemin}/${fichier}
    END

    ${fichiers}=    List Files In Directory    ${Chemins}    pattern=selenium-*
    FOR    ${fichier}    IN    @{fichiers}
        ${chemin_complet}=    Set Variable    ${Chemins}/${fichier}
        Remove File    ${chemin_complet}
        File Should Not Exist    ${chemin_complet}
    END

    ${autres}=    List Files In Directory    ${racine}    pattern=downloaded_image* 
    FOR    ${fichier}    IN    @{autres}
        ${chemin_complet}=    Set Variable    ${racine}/${fichier}
        Remove File    ${chemin_complet}
        File Should Not Exist    ${chemin_complet}
    END

    ${autres1}=    List Files In Directory    ${racine}    pattern=selenium-* 
    FOR    ${fichier}    IN    @{autres1}
        ${chemin_complet}=    Set Variable    ${racine}/${fichier}
        Remove File    ${chemin_complet}
        File Should Not Exist    ${chemin_complet}
    END

    
Suppr fichiers Selenium png
    [Arguments]     ${Chemin}   
    ${captures1}=    List Files In Directory    ${Chemin}    pattern=capture_*
    ${captures2}=    List Files In Directory    ${Chemin}    pattern=downloaded_image*
    ${captures3}=    List Files In Directory    ${Chemin}    pattern=logo*
    ${captures4}=    List Files In Directory    ${Chemin}    pattern=selenium-*
    
    ${captures}=     Combine Lists    ${captures1}    ${captures2}    ${captures3}    ${captures4}
    FOR    ${fichier}    IN    @{captures}
        Remove File    ${Chemin}/${fichier}
    END

    

Supprimer les fichiers Selenium png cas 2    
    [Arguments]     ${Chemin}   
    # # ${fichiers}=    List Files In Directory    ${Chemin}    pattern=capture_*
    # ${captures}=    List Files In Directory    ${Chemin}    pattern=capture_*
    # ${logos}=       List Files In Directory    ${Chemin}    pattern=logo
    # ${selenium}=    List Files In Directory    ${Chemin}    pattern=selenium-*
    # ${fichiers}=    Combine Lists    ${captures}    ${logos}    ${selenium}

    # FOR    ${fichier}    IN    @{fichiers}
    #     Remove File    ${Chemin}/${fichier}
    # END

    ${captures}=    List Files In Directory    ${Chemin}    pattern=capture_*
    FOR    ${fichier}    IN    @{captures}
        ${chemin_complet}=    Set Variable    ${Chemin}/${fichier}
        Remove File    ${Chemin}/${fichier}
    END

    ${logos}=    List Files In Directory    ${Chemin}    pattern=logo*
    FOR    ${fichier}    IN    @{logos}
        ${chemin_complet}=    Set Variable    ${Chemin}/${fichier}
        Remove File    ${Chemin}/${fichier}
    END

    ${fichiers}=    List Files In Directory    ${Chemin}    pattern=selenium-*
    FOR    ${fichier}    IN    @{fichiers}
        ${chemin_complet}=    Set Variable    ${Chemin}/${fichier}
        Remove File    ${chemin_complet}
        File Should Not Exist    ${chemin_complet}
    END










