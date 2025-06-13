*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
   
# Library    Collections
# Library    BuiltIn
# Library    DateTime



# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Resources/Keywords.robot





*** Variables ***

${Positive_Techo}         //*[contains(text(), 'Positive') and contains(text(), 'Technologie')]    
