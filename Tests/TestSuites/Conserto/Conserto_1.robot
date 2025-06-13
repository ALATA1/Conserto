*** Settings ***
Documentation    CONSERTO
Library    SeleniumLibrary
Library    OperatingSystem
Library    String


# Suite Setup     Nettoyer Dossier Logs
Resource         ../../../resources/Commun_conserto.robot



Test Setup       NONE  # Open Browser
Test Teardown    Close Browser  
# git push origin main:test


##############################################################                                                                   
#./Helpers/run-test.py -i CONSERTO --keepbrowseropened       #
#####################################################################################################################################
# robot Tests/TestSuites/Conserto/conserto_1.robot                                                                                  #
# robot -d Screenshot/ Tests/TestSuites/Conserto/conserto_1.robot                                                                   #
# robot -d Screenshot/ Tests/                                                                                                       #
# robot   --output Logs/output.xml   --log Logs/log.html   --report Logs/report.html   Tests/TestSuites/Conserto/conserto_1.robot   #
#####################################################################################################################################

*** Test Cases ***

Automatisation du site conserto
    [Documentation]       Scénario CONSERTO-CON0001 : Vérifier quelques éléments du site conserto.
    ...                   JDD : Salarié chez conserto, ayant une adresse mail et un mot de passe actifs.
    [Tags]    CON0001    ETAT:Stable    TYPE:CONSERTO     PRIORITE:P1 
    Ouverture Navigateur    ${URL_CONSERTO}
    Title Should Be    ${Title_1} 
    Vérifier Tous Les Mots Avec Une Boucle
    Action Scroll   ${footer}
    Capture Et Sauvegarde     capture_footer
    Nettoyer Dossier Logs
   


