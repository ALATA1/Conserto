*** Settings ***
Documentation       Les variables globales déclarées ou à appeler
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library    Collections
   
# Library    Collections
# Library    BuiltIn
# Library    DateTime



# Resource         ../../../Resources/Commun_conserto.robot
# Resource         ../../../Resources/Keywords.robot





*** Variables ***
${OPTIONS}=    add_argument(--headless)    add_argument(--disable-gpu)
...            add_argument(--no-sandbox)    add_argument(--disable-dev-shm-usage)
...            add_argument(--window-size=1920,1080)

${Conserto}                    //a[@class="hdr-logo-link" and @rel="home"]
${Positive_Techo}              //*[contains(text(), 'Positive') and contains(text(), 'Technologie')]    
${Barre_de_nav}                //nav[@id="nav-main" and @class="nav-main"]    #id=submit-button     # //*[@id="nav-main"]
# xpath=//nav[@id="nav-main" and .//h2[text()="Offre spéciale"]]
# //button[@id="darwin-zra-menubar" and @class="darwin-zra-menubar"]
${Positive}                    //a[contains(text(),"Positive")]
${historique}                  //div[@class='control-block']
${histo}                       //div[@class='control-items']
${annees_2013}                 //div[@class="item active" and @data-index="0"]
${Textes_complets_Positive}    //div[@class='text-wysiwyg']     #//*[contains(text(), '${Texte_Positive}') and contains(text(), '${Texte_Positive_2}')]
${Texte_Positive}              ${Texte_Positive_1}\n${Texte_Positive_2}
${Texte_Positive_1}            Nous pensons que la technologie doit avoir un impact positif sur l’avenir de tous.
${Texte_Positive_2}            La mission de Conserto est de cultiver le sens et les savoirs par la différence.
${Technologie}                 //a[contains(text(),"Technologie")]
${Clients}                     //a[contains(text(),"Nos clients")]
${Academy}                     //a[contains(text(),"Academy")]
${Blog}                        //a[contains(text(),"Blog")]
${Contact}                     //a[contains(text(),"Contact")]
${Positif_Techo_info}          Positive\nTechnologie
${Texte_Posit_Techo}           Positive
${postech}                     //div[@class='words-container']
${Mobile_menu}                 //button[@class='mobile-menu-button']
${Info_2013}                   //div[@class="slider-item" and @data-index="0"]/div/div[2]/div[@class='timeline-item__content']  



${Positive_texte}              POSITIVE
${Techo_texte}                 TECHNOLOGIE
${Clients_texte}               NOS CLIENTS
${Academy_texte}               ACADEMY
${Blog_texte}                  BLOG
${Contact_texte}               CONTACT

${Nav_texte}                   ${Positive_texte}\n${Techo_texte}\n${Clients_texte}\n${Academy_texte}\n${Blog_texte}\n${Contact_texte}




##########################################################################################
############################ VARIABLES IDNOW #############################################
@{Secteurs}    Banque traditionnelle    Assurances    Jeux    Voyage   
...    Ressources humaines   Fintech    Mobilité   Crypto   Télécommunication
@{Solutions}   Vérification d’identité automatisée    Vérification d’identité en personne    
...    Vérification d’identité guidée par des experts    Services de confiance
@{Centre de connaissances}    Blog    Cas Clients    Webinaires    
...    Rapports et guides    Glossaire    Pôle développeurs
@{Société}    Presse    Carrières    Nos valeurs    Partenaires    Références    À propos
@{Contact}    Support utilisateurs    Contactez notre équipe de ventes  


${Barre_de_nav_Idnow}          //nav[@class='site-nav']
${Barre_de_nav_Idnow2}         //*[@id="menu-navigation-fr"]


${Texte1_activite}         Nous transformons la confiance en avantage stratégique.
${Texte2_activite}         Grâce à nos solutions d’identité SaaS pilotées par l’IA, vous bénéficiez d’une sécurité extensible, d’une conformité évolutive et d’une prévention de la fraude en temps réel. De quoi naviguer sereinement dans un monde digital complexe.