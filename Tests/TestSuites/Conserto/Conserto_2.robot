*** Settings ***
Documentation    CONSERTO
Library    SeleniumLibrary
Library    OperatingSystem
Library    String


# Suite Setup     Nettoyer Dossier Logs
Resource         ../../../Resources/Commun_conserto.robot
Resource         ../../../Resources/Keywords.robot
Resource         ../../../Variables/Global_variables.robot


# Test Setup       NONE  # Open Browser
# Test Teardown    NONE  # Close Browser  
# git push origin main:test
# Jenkins : Id = Test_Cons

Test Setup      Prérequis test   # NONE   Préparer Test
Test Teardown   Close Browser   # Capture Erreur Unique

##############################################################                                                                   
#./Helpers/run-test.py -i CONSERTO --keepbrowseropened       #
#####################################################################################################################################
# robot Tests/TestSuites/Conserto/conserto_1.robot                                                                                  #
# robot -d Screenshot/ Tests/TestSuites/Conserto/conserto_1.robot                                                                   #
# robot -d Screenshot/ Tests/                                                                                                       #
# robot -d Resultats/ Tests/                                                                                                        #
# robot -d Resultats/ Tests/TestSuites/Conserto/conserto_2.robot                                                                           #
# robot   --output Logs/output.xml   --log Logs/log.html   --report Logs/report.html   Tests/TestSuites/Conserto/conserto_1.robot   #
#####################################################################################################################################

*** Test Cases ***

Automatisation du site conserto cas 2
    [Documentation]       Scénario CONSERTO-CON0001 : Vérifier quelques éléments du site conserto.
    ...                   JDD : Salarié chez conserto, ayant une adresse mail et un mot de passe actifs.
    [Tags]    CON0001    ETAT:Stable    TYPE:CONSERTO     PRIORITE:P1 
    Ouverture Navigateur    ${URL_CONSERTO}    Hors mobile      # Hors mobile  Avec Mobile
    Page Accueil verif titre   ${Title_1} 
    Barre du menu navigation 
    Test navigation fonctionne 
    Vérifier logo   ${Conserto}   
    Verif positive techologie    ${Positif_Techo_info}   
    # Verif elements ilots   # ${Positive}
    # Cliquer sur un lien ilots    Infra
    # Wait Until Element Is Visible    ${Ilots_Infra}    10
    # Wait Until Keyword Succeeds    2 x    2 s    Click Element    ${Ilots_Infra}
    # Wait Until Keyword Succeeds	    5s	3s      Click Element    ${Conserto}
    Ilots    ${Ilots_Culture_Agile}
    Ilots    ${Ilots_Infra}
    Ilots    ${Ilots_Devops}
    Ilots    ${Ilots_Dev}
    Ilots    ${Ilots_Agence_Web}
    


    # # Lancer Chrome En Headless    ${URL_CONSERTO}
    # # Page d'accueil de Conserto cas 2   ${Title_1} 
      
    # # Nettoyer Dossier Logs
    # # Nettoyer Dossier Resultats
    # # Nettoyer les captures 
    # # # Test navigation fonctionne

    # # Conditions menu nav     Positive
    # # # Values nav    Positive
    # # Values nav2   ${Barre_de_nav}   ${Mobile_menu}
    # # # Culture agile
    # # # Culture Technologie
    # # # Culture Clients 
    # # # Culture Academy
    # # # Culture Blog
    # # # Culture Contact
    
    
    # # Test navigation fonctionne


    

    

    # # Verif positive techo   ${postech}   ${Positif_Techo_info} 
    # Verif ilots    ${Positive}





    
