#!python

import sys
import os
import subprocess
import sys



def install_packages():
    packages = [
        "robotframework",
        "robotframework-seleniumlibrary",
        "selenium",
        "webdriver-manager"
    ]
    for package in packages:
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])

if __name__ == "__main__":
    install_packages()



# 1. Un fichier personnalisé (install_helpers.py) dans un projet
# Un projet Robot Framework peut contenir un fichier install_helpers.py pour :
#     - Installer des bibliothèques ou outils nécessaires.
#     - Télécharger ou configurer des ressources (navigateur, drivers, etc.).
#     - Automatiser la configuration d’un environnement de test.


# 2. Utilisé dans des projets open-source ou internes
# Certains projets open-source ou internes peuvent contenir ce fichier dans leur dépôt Git. 
# Par exemple, un projet utilisant Robot Framework + Playwright + Python pourrait avoir un tel fichier pour préparer l’environnement.






