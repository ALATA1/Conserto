*** Settings ***
Documentation    CONSERTO
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections


# Suite Setup     Nettoyer Dossier Logs
Resource         ../../../Resources/Commun_conserto.robot
Resource         ../../../Resources/Keywords.robot
Resource         ../../../Variables/Global_variables.robot


Test Setup       NONE  # Open Browser
Test Teardown    Close Browser  
# git push origin main:test
# Jenkins : Id = Test_Cons

##############################################################                                                                   
#./Helpers/run-test.py -i CONSERTO --keepbrowseropened       #
#####################################################################################################################################
# robot Tests/TestSuites/Conserto/conserto_1.robot                                                                                  #
# robot -d Screenshot/ Tests/TestSuites/Conserto/conserto_1.robot                                                                   #
# robot -d Screenshot/ Tests/                                                                                                       #
# robot -d Resultats/ Tests/                                                                                                        #
# robot -d Resultats/ Tests/TestSuites/Idnow/Idnow.robot                                                                            #
# robot   --output Logs/output.xml   --log Logs/log.html   --report Logs/report.html   Tests/TestSuites/Conserto/conserto_1.robot   #
#####################################################################################################################################

*** Test Cases ***

Automatisation du site idnow
    [Documentation]       Scénario IDNOW-CON0001 : Vérifier quelques éléments du site IDNOW.
    ...                   JDD : Salarié ou sociétaire chez IDNOW, ayant une adresse mail et un mot de passe actifs.
    [Tags]    IDNOW    ETAT:Stable    TYPE:TEST     PRIORITE:P1 
    Ouverture Navigateur    ${URL_IDNOW}   ${BROWSER}       # ${BROWSER}  ${BROWSER_2}    ${BROWSER_3}      
    Accepter les cookies    Autoriser tous les cookies      # Autoriser tous les cookies   Paramètres des cookies
    Verif title    ${Title_Idnow}
    Verif textes page acceuil      ${Texte1_activite}     ${Texte2_activite}
    Barre de Nav Idnow    ${Barre_de_nav_Idnow}    
    Barre de Nav Idnow    ${Barre_de_nav_Idnow2}
    Action nav Idnow      Secteurs   Assurances
    Afficher Tous Les cas     Solutions    ${Solutions}[0]
    # Nettoyer Dossier Logs
    # Test navigation fonctionne




    
