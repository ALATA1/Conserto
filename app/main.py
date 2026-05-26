from fastapi import FastAPI, Form, Depends, HTTPException
from fastapi.responses import HTMLResponse, RedirectResponse, StreamingResponse
from fastapi.security import OAuth2PasswordRequestForm
from fastapi import Form
from io import BytesIO
from openpyxl import Workbook
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from typing import List, Union, Optional
from app.api.auth import hash_password
from fastapi import Request
from jose import jwt, JWTError
from datetime import datetime

from app.database.database import engine
from app.database.base import Base
from app.core.middleware import AuditMiddleware



Base.metadata.create_all(bind=engine)


from app.data.users import users_db
from app.api.auth import hash_password, verify_password, create_access_token

from app.api.auth import (
    hash_password,
    verify_password,
    create_access_token
)

SECRET_KEY = "conserto_secret_key"
ALGORITHM = "HS256"

app = FastAPI()

app.add_middleware(AuditMiddleware)

from starlette.middleware.sessions import SessionMiddleware

app.add_middleware(
    SessionMiddleware,
    secret_key="conserto-secret-key"
)



# # ===============================
# # UTILISATEURS DE L'APPLICATION
# # ===============================

# users_db = {
#     "ibrahima.alata@conserto.pro": {
#         "username": "ibrahima.alata@conserto.pro",
#         "hashed_password": hash_password("admin"),
#         "role": "ADMIN"
#     },

#     "alice.martin@conserto.pro": {
#         "username": "alice.martin@conserto.pro",
#         "hashed_password": hash_password("admin123"),
#         "role": "MANAGER"
#     },

#     "helene.martin@conserto.pro": {
#         "username": "helene.martin@conserto.pro",
#         "hashed_password": hash_password("MonPassword123"),
#         "role": "RH"
#     }
# }

def get_current_user(request: Request):
    
    token = request.cookies.get("access_token")

    if not token:
        return None

    try:
        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )

        username = payload.get("sub")

        if username is None:
            return None

        return users_db.get(username)

    except JWTError:
        return None
    

# ==============================
# FONCTION UTILISATEUR CONNECTE 
# ==============================

@app.post("/login")
def login(request: Request, form_data: OAuth2PasswordRequestForm = Depends()):

    user = users_db.get(form_data.username)

    if not user:
        raise HTTPException(status_code=401, detail="Utilisateur incorrect")

    if not verify_password(form_data.password, user["hashed_password"]):
        raise HTTPException(status_code=401, detail="Mot de passe incorrect")

    token = create_access_token({
        "sub": form_data.username,
        "role": user["role"]
    })

    response = RedirectResponse(url="/", status_code=303)

    # 🔥 IMPORTANT : on stocke le token dans un cookie
    response.set_cookie(
        key="access_token",
        value=token,
        httponly=True
    )

    return response


# =========================
# PROFILS
# =========================
PROFILS = [
    "Développeur",
    "Testeur fonctionnel",
    "Testeur Automaticien",
    "Devops",
    "Business Analyst",
    "Data analyst",
    "Agile master",
    "Coach agile",
    "Architecte data",
    "Data engineer",
    "Ing. Système Linux",
    "Sécurité et réseau"
]

# =========================
# COMPÉTENCES
# =========================
COMPETENCES = {
    "Langages": [
        "Apache Nifi", "Angular 17", "Angular 19", "CSS", "HTML",
        "Hibernate", "Java 8", "Java 21", "Java 25",
        "Jasper report", "Javascript", "Maven 3", "NPM/NodeJS",
        "Open Feign", "RGAA", "Spring", "Spring Batch",
        "SCSS", "Typescript 5"
    ],

    "Protocole": ["JSON", "REST", "SOAP", "XML"],

    "Bases de données": [
        "Oracle",
        "Oracle SQL Developer",
        "PG Admin",
        "PostgreSQL"
    ],

    "Devops/Infra": [
        "Apache", "Docker", "Docker Compose",
        "Docker Swarm", "Git", "Gitlab",
        "GitlabCI", "Helm", "Kubernetes",
        "kubctl", "Linux Ubuntu", "Nginx",
        "Scripts Shell", "Tomcat", "SonarQube"
    ],

    "Tests": [
        "ArchUnit", "Cypress", "Castle Mock",
        "JUnit", "Mockito", "MockServer",
        "Postman", "Playwright",
        "Robotframework", "SoapUi",
        "Jasmine/Karma"
    ],

    "Perf": ["Gatling", "Jmeter"]
}

AGENCES = [
    "Bordeaux",
    "Lyon",
    "Montpellier",
    "Nantes",
    "Niort",
    "Paris",
    "Rennes",
    "Toulouse"
]

# =========================
# LEGENDES TOOLTIP
# =========================
LEG_NIVEAU = """
0 = Pas de notion
1 = Connaissances
2 = Travail supervisé
3 = Autonomie limitée
4 = Maîtrise et autonomie totale
5 = Maîtrise et enseignement
"""

LEG_APPETENCE = """
0 = Aversion
1 = Peu d'intérêt
2 = Curiosité
3 = Intéressé
4 = Très intéressé
5 = Vital
"""

# =========================
# DATA
# =========================
collaborateurs = [
    {
        "id": 1,
        "nom": "Ibrahima",
        "prenom": "Alata",
        "profil": "Testeur Automaticien",
        "agence": "Niort",
        "competence": ["Robotframework", "Playwright"],
        "niveau": 4,
        "niveau_attendu": 5
    },
    {
        "id": 2,
        "nom": "Alice",
        "prenom": "Martin",
        "profil": "Développeur",
        "agence": "Lyon",
        "competence": ["PostgreSQL"],
        "niveau": 3,
        "niveau_attendu": 4
    }
]

# =========================
# AUDIT LOG
# =========================
audit_logs = []

def log_action(user, action, details):
    audit_logs.append({
        "date": datetime.now().strftime("%d/%m/%Y %H:%M:%S"),
        "user": user["username"],
        "action": action,
        "details": details
    })

# ============================
# ACTIONS CODE COULEUR NIVEAU
# ============================

def format_niveau(n):
    try:
        n = int(n)
    except:
        return '<span class="niveau-rouge" title="Valeur invalide">?</span>'

    if n <= 1:
        label = "Débutant"
        cls = "niveau-rouge"
    elif n <= 3:
        label = "Intermédiaire"
        cls = "niveau-orange"
    elif n <= 5:
        label = "Expert"
        cls = "niveau-vert"
    else:
        return f'<span class="niveau-rouge" title="Invalide">{n}</span>'

    return f'<span class="{cls}" title="{label}">{n}</span>'
    

# =========================
# HELPERS
# =========================
def normalize_data():
    for c in collaborateurs:
        if isinstance(c["competence"], str):
            c["competence"] = [c["competence"]]

normalize_data()


def normalize_competence(value):
    if not value:
        return []

    if isinstance(value, list):
        return value

    return [value]


def clamp(v):
    return max(0, min(5, int(v)))



# ============================================
# AJOUT DE LA ROUTE LOGIN BACK END - SWAGGER
# ============================================

@app.post("/login")
def login(request: Request, form_data: OAuth2PasswordRequestForm = Depends()):

    user = users_db.get(form_data.username)

    if not user:
        raise HTTPException(status_code=401, detail="Utilisateur incorrect")

    if not verify_password(form_data.password, user["hashed_password"]):
        raise HTTPException(status_code=401, detail="Mot de passe incorrect")

    token = create_access_token({
        "sub": form_data.username,
        "role": user["role"]
    })

    response = RedirectResponse(url="/", status_code=303)

    #  IMPORTANT : on stocke le token dans un cookie
    response.set_cookie(
        key="access_token",
        value=token,
        httponly=True
    )

    return response



# =========================================
# AJOUTER LOGIN AUTHENTIFICATION FRONT END
# =========================================

@app.get("/login", response_class=HTMLResponse)
def login_page():
    return """
    <html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <title>Connexion</title>
    </head>

    <body class="bg-light">

    <div class="container mt-5" style="max-width:400px;">

        <h3 class="mb-3">Connexion</h3>

        <form method="post" action="/login">

            <input class="form-control mb-2" name="username" placeholder="Username" required>

            <input class="form-control mb-3" type="password" name="password" placeholder="Password" required>

            <button class="btn btn-primary w-100">Se connecter</button>

        </form>

    </div>

    </body>
    </html>
    """

# =========================
# AJOUTER LA ROUTE LOGOUT
# =========================
@app.get("/logout")
def logout():
    response = RedirectResponse(url="/login", status_code=303)
    response.delete_cookie("access_token")
    return response


# =========================
# HOME
# =========================
    
@app.get("/", response_class=HTMLResponse)
def home(
    request: Request,
    agence: str = None,
    competence: str = None,
    search: str = None,
    profil: str = None,
    error: str = None
):    

    data = collaborateurs

    current_user = get_current_user(request)

    if not current_user:
        return RedirectResponse("/login", status_code=303)

    is_logged = True

    if not current_user:
        return RedirectResponse(
            url="/login",
            status_code=303
        )

    if agence:
        data = [c for c in data if c["agence"] == agence]

    if competence:
        data = [c for c in data if competence in c["competence"]]

    if search:
        data = [
            c for c in data
            if search.lower() in c["nom"].lower()
            or search.lower() in c["prenom"].lower()
        ]

    if profil:
        data = [c for c in data if c["profil"] == profil]

    total = len(data)

    avg = round(
        sum(c["niveau"] for c in data) / total,
        1
    ) if total else 0

    html = f"""
    <html>

    <head>

        <title>Skills Matrix</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
        >

        <style>

            body {{
                background:#f8f9fa;
            }}

            .skill-badge {{
                cursor:pointer;
                font-size:12px;
            }}

            .table td {{
                vertical-align:middle;
            }}

            .niveau-rouge {{
            color: #dc3545;
            font-weight: 600;
        }}

        .niveau-orange {{
            color: #fd7e14;
            font-weight: 600;
        }}

        .niveau-vert {{
            color: #28a745;
            font-weight: 600;
        }}
        </style>

    </head>

    <body>

    <div class="container mt-4">

        
        <div class="d-flex justify-content-between align-items-center mb-4">

            <h2>Skills Matrix</h2>

            {
                f'''
                <a href="/logout" class="btn btn-danger">
                    Déconnexion
                </a>
                '''
                if is_logged else
                '''
                <a href="/login" class="btn btn-primary">
                    Connexion
                </a>
                '''
            }

        </div>

        <div class="alert alert-info fw-bold">
            Échelle de notation : Survoler les champs niveau et appétence pour voir les légendes.
        </div>

        <div class="row mb-3">

            <div class="col card p-3 m-2">
                Total collaborateurs : {total}
            </div>

            <div class="col card p-3 m-2">
                Moyenne niveau : {avg}
            </div>

        </div>

        <!-- EXPORT -->
        <div class="mb-3">

            <a href="/export/excel"
               class="btn btn-dark">
                Export Excel
            </a>

            <a href="/export/pdf"
               class="btn btn-danger">
                Export PDF
            </a>

        </div>

        <!-- ADD -->
        <form class="card p-3 mb-4" action="/add" method="post">

            <div class="row">
                <div class="col"><input class="form-control" name="nom" placeholder="Nom*" required></div>
                <div class="col"><input class="form-control" name="prenom" placeholder="Prénom*" required></div>

                <div class="col">
                    <select class="form-control" name="profil" required>
                        <option value="">Profil*</option>
                        {"".join([f'<option value="{p}">{p}</option>' for p in PROFILS])}
                    </select>
                </div>

                <div class="col">
                    <select class="form-control" name="agence" required>
                        <option value="">Agence*</option>
                        {"".join([f'<option value="{a}">{a}</option>' for a in AGENCES])}
                    </select>
                </div>
            </div>

            <div class="row mt-2">
<!--
                <div class="col">
                    <select class="form-control" name="competence" required>
                        <option value="">Compétence</option>
                        {"".join([
                            f'<optgroup label="{g}">{"".join([f"<option value={s}>{s}</option>" for s in skills])}</optgroup>'
                            for g, skills in COMPETENCES.items()
                        ])}
                    </select>
                </div>
-->


                <!-- COMPETENCE -->
                <!-- COMPETENCE -->
                <div class="col">

                    <div class="dropdown w-100">

                        <button
                            class="btn btn-outline-secondary dropdown-toggle w-100 text-start d-flex align-items-center"
                            type="button"
                            data-bs-toggle="dropdown"
                            id="competenceBtn"
                            style="height:38px;"
                        >
                            Compétences*
                        </button>

                        <div class="dropdown-menu p-3 w-100"
                            style="max-height:250px; overflow:auto;">

                            {''.join([
                                f"<div class='fw-bold mt-2'>{g}</div>" +
                                ''.join([
                                    f"""
                                    <div class="form-check">

                                        <input
                                            class="form-check-input competence-check"
                                            type="checkbox"
                                            name="competence"
                                            value="{s}"
                                            onchange="validateCompetence()"
                                        >

                                        <label class="form-check-label">
                                            {s}
                                        </label>

                                    </div>
                                    """
                                    for s in skills
                                ])
                                for g, skills in COMPETENCES.items()
                            ])}

                        </div>

                    </div>

                    <!-- VALIDATEUR HTML5 -->
                    <input
                        type="text"
                        id="competence-validator"
                        required
                        style="
                            position:absolute;
                            opacity:0;
                            height:0;
                            width:0;
                            pointer-events:none;
                        "
                    >

                </div>

                <script>

                    function validateCompetence() {{

                        const checked =
                            document.querySelectorAll(".competence-check:checked");

                        const validator =
                            document.getElementById("competence-validator");

                        if (checked.length > 0) {{
                            validator.value = "ok";
                        }} else {{
                            validator.value = "";
                        }}
                    }}

                    validateCompetence();

                </script>



                <div class="col">
                    <input class="form-control" name="niveau" type="number"
                        min="0" max="5" placeholder="Niveau*"
                        title="{LEG_NIVEAU}" required>
                </div>
             
                <div class="col">
                    <input class="form-control" name="niveau_attendu" type="number"
                        min="0" max="5" placeholder="Appétence*"
                        title="{LEG_APPETENCE}" required>
                </div>

                <div class="col">
                    <button class="btn btn-primary w-100">Ajouter</button>
                </div>
            </div>
        </form>

        <!-- FILTERS -->
        <form class="card p-3 mb-4"
              method="get">

            <div class="row">

                <div class="col">
                    <input
                        class="form-control"
                        name="search"
                        placeholder="Nom / Prénom"
                    >
                </div>

                <div class="col">

                    <select class="form-control"
                            name="profil">

                        <option value="">
                            Profil
                        </option>

                        {"".join([
                            f'<option value="{p}">{p}</option>'
                            for p in PROFILS
                        ])}

                    </select>

                </div>

                <div class="col">

                    <select class="form-control"
                            name="agence">

                        <option value="">
                            Agence
                        </option>

                        {"".join([
                            f'<option value="{a}">{a}</option>'
                            for a in AGENCES
                        ])}

                    </select>

                </div>

                <div class="col">

                    <select class="form-control"
                            name="competence">

                        <option value="">
                            Compétence
                        </option>

                        {"".join([
                            f'''
                            <optgroup label="{g}">
                                {"".join([
                                    f'<option value="{s}">{s}</option>'
                                    for s in skills
                                ])}
                            </optgroup>
                            '''
                            for g, skills in COMPETENCES.items()
                        ])}

                    </select>

                </div>

                <div class="col">
                    <button class="btn btn-success w-100">
                        Filtrer
                    </button>
                </div>

                <div class="col">
                    <a href="/"
                       class="btn btn-secondary w-100">
                        Reset
                    </a>
                </div>

            </div>

        </form>

        <!-- TABLE -->
        <table class="table table-striped table-bordered bg-white">

            <thead class="table-dark">

                <tr>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Profil</th>
                    <th>Agence</th>
                    <th>Compétences</th>
                    <th>Niveau</th>
                    <th>Appétence</th>
                    <th>Actions</th>
                </tr>

            </thead>

            <tbody>
    """

    for c in data:

        competences_html = ""

        for comp in c["competence"]:

            competences_html += f"""
            <span
                class="badge bg-primary me-1 mb-1 skill-badge"
                onclick="openDeleteModal(
                    {c['id']},
                    '{comp}',
                    {len(c["competence"])}
                )"
            >
                {comp} ✕
            </span>
            """

        html += f"""
        <tr>

            <td>{c['nom']}</td>
            <td>{c['prenom']}</td>
            <td>{c['profil']}</td>
            <td>{c['agence']}</td>

            <td>
                {competences_html}
            </td>

            <!--<td>{c['niveau']}</td>-->
            <td>{format_niveau(c['niveau'])}</td>

            <td>{c['niveau_attendu']}</td>

            <td>

                <a href="/edit/{c['id']}"
                class="btn btn-warning btn-sm">
                    ✏️
                </a>

                <button
                    class="btn btn-danger btn-sm"
                    onclick="openDeleteCollaborateurModal(
                        {c['id']},
                        '{c['nom']}',
                        '{c['prenom']}'
                    )"
                >
                    🗑
                </button>

            </td>

        </tr>
        """

    html += """
            </tbody>

        </table>

    </div>

    <!-- MODAL DELETE COMPETENCE -->
    <div class="modal fade"
         id="deleteCompetenceModal"
         tabindex="-1">

        <div class="modal-dialog">

            <div class="modal-content">

                <div class="modal-header">

                    <h5 class="modal-title"
                        id="deleteModalTitle">
                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body"
                     id="deleteModalBody">
                </div>

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">
                        Annuler
                    </button>

                    <a id="confirmDeleteBtn"
                       href="#"
                       class="btn btn-danger">
                        Supprimer
                    </a>

                </div>

            </div>

        </div>

    </div>

    <!-- MODAL DELETE COLLABORATEUR -->
    <div class="modal fade"
         id="deleteCollaborateurModal"
         tabindex="-1">

        <div class="modal-dialog">

            <div class="modal-content">

                <div class="modal-header">

                    <h5 class="modal-title">
                        Supprimer le collaborateur
                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body"
                     id="deleteCollaborateurBody">
                </div>

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">
                        Annuler
                    </button>

                    <a id="confirmDeleteCollaborateurBtn"
                       href="#"
                       class="btn btn-danger">
                        Supprimer
                    </a>

                </div>

            </div>

        </div>

    </div>
    """

    if error == "last_competence":

        html += """
        <div class="modal fade show"
             id="infoModal"
             tabindex="-1"
             style="display:block; background:rgba(0,0,0,0.5);">

            <div class="modal-dialog">

                <div class="modal-content">

                    <div class="modal-header">

                        <h5 class="modal-title">
                            Suppression impossible
                        </h5>

                    </div>

                    <div class="modal-body">

                        Le collaborateur doit conserver
                        au moins une compétence.

                    </div>

                    <div class="modal-footer">

                        <a href="/"
                           class="btn btn-primary">
                            OK
                        </a>

                    </div>

                </div>

            </div>

        </div>
        """

    html += """
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>

        // =========================
        // DELETE COMPETENCE
        // =========================
        function openDeleteModal(id, competence, nbCompetences) {

            const title =
                document.getElementById("deleteModalTitle");

            const body =
                document.getElementById("deleteModalBody");

            const confirmBtn =
                document.getElementById("confirmDeleteBtn");

            if (parseInt(nbCompetences) <= 1) {

                title.innerText =
                    "Suppression impossible";

                body.innerHTML =
                    "Le collaborateur doit conserver " +
                    "au moins une compétence.";

                confirmBtn.style.display = "none";

            } else {

                title.innerText =
                    "Supprimer la compétence";

                body.innerHTML =
                    "Voulez-vous vraiment supprimer : " +
                    "<b>" + competence + "</b> ?";

                confirmBtn.style.display = "inline-block";

                confirmBtn.href =
                    "/remove-competence/" +
                    id +
                    "?comp=" +
                    encodeURIComponent(competence);
            }

            const modal = new bootstrap.Modal(
                document.getElementById(
                    "deleteCompetenceModal"
                )
            );

            modal.show();
        }

        // =========================
        // DELETE COLLABORATEUR
        // =========================
        function openDeleteCollaborateurModal(
            id,
            nom,
            prenom
        ) {

            const body =
                document.getElementById(
                    "deleteCollaborateurBody"
                );

            const confirmBtn =
                document.getElementById(
                    "confirmDeleteCollaborateurBtn"
                );

            body.innerHTML =
                "Voulez-vous vraiment supprimer : <br>" +
                "<b>" +
                nom +
                " " +
                prenom +
                "</b> ?";

            confirmBtn.href =
                "/delete/" + id;

            const modal = new bootstrap.Modal(
                document.getElementById(
                    "deleteCollaborateurModal"
                )
            );

            modal.show();
        }

    </script>

    </body>
    </html>
    """

    return HTMLResponse(content=html)


# =========================
# ADD/AJOUT
# =========================

@app.post("/add")
def add(
    request: Request,
    nom: str = Form(...),
    prenom: str = Form(...),
    profil: str = Form(...),
    agence: str = Form(...),
    competence: Optional[Union[List[str], str]] = Form(None),
    niveau: int = Form(...),
    niveau_attendu: int = Form(...)
):

    user = get_current_user(request)

    if not user:
        raise HTTPException(status_code=401, detail="Non autorisé")

    competence = normalize_competence(competence)

    collaborateurs.append({
        "id": max([c["id"] for c in collaborateurs], default=0) + 1,
        "nom": nom,
        "prenom": prenom,
        "profil": profil,
        "agence": agence,
        "competence": competence,
        "niveau": clamp(niveau),
        "niveau_attendu": clamp(niveau_attendu)
    })

    log_action(user, "AJOUT", f"{prenom} {nom}")

    return RedirectResponse("/", status_code=303)

# =========================
# DELETE COLLABORATEUR
# =========================
@app.get("/delete/{id}")
def delete(request: Request, id: int):

    user = get_current_user(request)

    if not user:
        raise HTTPException(status_code=401, detail="Non autorisé")

    global collaborateurs

    collaborateur = next((c for c in collaborateurs if c["id"] == id), None)

    collaborateurs = [
        c for c in collaborateurs
        if c["id"] != id
    ]

    if collaborateur:
        log_action(user, "SUPPRESSION", f"{collaborateur['prenom']} {collaborateur['nom']}")

    return RedirectResponse("/", status_code=303)


# =========================
# REMOVE COMPETENCE
# =========================
@app.get("/remove-competence/{id}")
def remove_competence(id: int, comp: str):

    for c in collaborateurs:

        if c["id"] == id:

            if len(c["competence"]) <= 1:
                return RedirectResponse("/?error=last_competence", status_code=303)

            c["competence"] = [
                x for x in c["competence"]
                if x != comp
            ]
            break

    return RedirectResponse("/", status_code=303)




# =========================
# EDIT PAGE
# =========================
@app.get("/edit/{id}", response_class=HTMLResponse)
def edit(id: int):

    c = next((x for x in collaborateurs if x["id"] == id), None)

    if not c:
        return RedirectResponse("/")

    c["competence"] = normalize_competence(c["competence"])

    html = f"""
    <html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <title>Edit</title>
        <style>
            .required-star {{
                color: red;
                margin-left: 3px;
            }}
        </style>
    </head>

    <body class="bg-light">
    <div class="container mt-4">

        <h3>Modifier la matrice de compétance du collaborateur</h3>

        <div class="alert alert-info">
            Survoler les champs pour afficher les légendes :
            Niveau (compétence) / Appétence (motivation)
        </div>

        <form class="card p-4" method="post" action="/update/{id}">

            <div class="row g-3">

                <!-- NOM -->
                <div class="col-12 col-md-6">
                    <label class="form-label">
                        Nom <span class="text-danger">*</span>
                    </label>
                    <input class="form-control" name="nom" value="{c['nom']}" required>
                </div>

                <!-- PRENOM -->
                <div class="col-12 col-md-6">
                    <label class="form-label">
                        Prénom <span class="text-danger">*</span>
                    </label>
                    <input class="form-control" name="prenom" value="{c['prenom']}" required>
                </div>

                <!-- PROFIL -->
                <div class="col-12 col-md-4">
                    <label class="form-label">
                        Profil <span class="text-danger">*</span>
                    </label>
                    <select class="form-select" name="profil" required>
                        {"".join([f'<option value="{p}" {"selected" if p==c["profil"] else ""}>{p}</option>' for p in PROFILS])}
                    </select>
                </div>

                <!-- AGENCE -->
                <div class="col-12 col-md-4">
                    <label class="form-label">
                        Agence <span class="text-danger">*</span>
                    </label>
                    <select class="form-select" name="agence" required>
                        {"".join([f'<option value="{a}" {"selected" if a==c["agence"] else ""}>{a}</option>' for a in AGENCES])}
                    </select>
                </div>

                <!-- COMPETENCE -->
                
                <div class="col-12 col-md-4">
                    <label class="form-label">
                        Compétence <span class="text-danger">*</span>
                    </label>

                   <!-- COMPETENCE VERSION LISTE DEROULANTE --> 
                   <!--
                    <select class="form-select" name="competence" required>

                        <option value="">Compétence</option>

                        {"".join([
                            f'''
                            <optgroup label="{g}">
                                {"".join([
                                    f'<option value="{s}" {"selected" if s == c["competence"] else ""}>{s}</option>'
                                    for s in skills
                                ])}
                            </optgroup>
                            '''
                            for g, skills in COMPETENCES.items()
                        ])}

                    </select>
                    -->
                    
                    <!-- COMPETENCE VERSION CASES A COCHER --> 

                    <!-- COMPETENCE VERSION CASES A COCHER -->

                    <div class="dropdown w-100">

                        <button
                            class="btn btn-outline-secondary dropdown-toggle w-100 text-start d-flex align-items-center"
                            type="button"
                            data-bs-toggle="dropdown"
                            id="competenceBtn"
                            style="height:38px;"
                        >
                            Sélectionner vos compétences
                        </button>

                        <div class="dropdown-menu p-3 w-100"
                            style="max-height:250px; overflow:auto;">

                            {''.join([

                                f"<div class='fw-bold mt-2'>{g}</div>" +

                                ''.join([

                                    f"""
                                    <div class="form-check">

                                        <input
                                            class="form-check-input competence-check"
                                            type="checkbox"
                                            name="competence"
                                            value="{s}"
                                            {"checked" if s in c["competence"] else ""}
                                        >

                                        <label class="form-check-label">
                                            {s}
                                        </label>

                                    </div>
                                    """

                                    for s in skills

                                ])

                                for g, skills in COMPETENCES.items()

                            ])}

                        </div>

                    </div>

                </div>

                <!-- NIVEAU -->
                <div class="col-12 col-md-6">
                    <label class="form-label">
                        Niveau <span class="text-danger">*</span>
                    </label>
                    <input class="form-control" name="niveau" type="number"
                        min="0" max="5"
                        value="{c['niveau']}"
                        title="{LEG_NIVEAU}" required>
                </div>

                <!-- APPETENCE -->
                <div class="col-12 col-md-6">
                    <label class="form-label">
                        Appétence <span class="text-danger">*</span>
                    </label>
                    <input class="form-control" name="niveau_attendu" type="number"
                        min="0" max="5"
                        value="{c['niveau_attendu']}"
                        title="{LEG_APPETENCE}" required>
                </div>

            </div>

            <!-- ACTIONS -->
            <div class="mt-4 d-flex gap-2">

                <!-- <button type="button" class="btn btn-success" onclick="confirmSave(event)">  
                <button class="btn btn-success"> -->
                <button type="button" id="saveBtn" class="btn btn-success" disabled onclick="confirmSave(event)">
                    Sauvegarder
                </button>

                <a href="/" class="btn btn-secondary" onclick="confirmCancel(event)">
                    Annuler
                </a>

            </div>

            


        </form>

    </div>


    <!-- MODAL -->
    <div class="modal fade" id="cancelModal" tabindex="-1">

        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">

                    <h5 class="modal-title">
                        Quitter sans enregistrer
                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body">
                    Vous allez perdre toutes vos modifications.
                </div>

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">
                        Annuler
                    </button>

                    <a href="/"
                       class="btn btn-danger">
                        Quitter
                    </a>

                </div>

            </div>
        </div>

    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
                
        let formModified = false;

        const saveBtn = document.getElementById("saveBtn");
        const form = document.querySelector("form");

        // Détection modification formulaire
        document.querySelectorAll("input, select").forEach(function(element) {{

            element.addEventListener("input", function() {{
                formModified = true;
            }});

            element.addEventListener("change", function() {{
                formModified = true;
            }});

        }});


        // Gestion bouton Annuler
        function confirmCancel(event) {{

            // aucune modification
            if (!formModified) {{
                return true;
            }}

            // bloque navigation
            event.preventDefault();

            // ouvre modal bootstrap
            let modal = new bootstrap.Modal(
                document.getElementById('cancelModal')
            );

            modal.show();

            return false;
        }}

        
        // snapshot initial du formulaire

        function getFormState() {{

            const state = {{}};

            document.querySelector("form").querySelectorAll("input, select").forEach(el => {{

                if (el.type === "checkbox") {{

                    if (!state[el.name]) state[el.name] = [];

                    if (el.checked) {{
                        state[el.name].push(el.value);
                    }}

                }} else {{
                    state[el.name] = el.value;
                }}

            }});

            return JSON.stringify(state);
        }}

        const initialState = getFormState();

        // validation champs (rouge si vide)
        function validateFields() {{

            let valid = true;

            form.querySelectorAll("input, select").forEach(el => {{

                if (el.type !== "checkbox" && !el.value) {{
                    el.classList.add("is-invalid");
                    valid = false;
                }} else {{
                    el.classList.remove("is-invalid");
                }}

            }});

            return valid;
        }}

        // check global
        function checkForm() {{

            const currentState = getFormState();

            formModified = (currentState !== initialState);

            const valid = validateFields();

            saveBtn.disabled = !(formModified && valid);
        }}

        // écoute des changements
        form.querySelectorAll("input, select").forEach(el => {{

            el.addEventListener("input", checkForm);
            el.addEventListener("change", checkForm);

        }});

        // init
        checkForm();

        // sauvegarde
        function confirmSave(event) {{

            if (!formModified) {{

                const modal = new bootstrap.Modal(
                    document.getElementById('saveModal')
                );

                modal.show();
                return;
            }}

            form.submit();
        }}

        // MAJ affichage bouton compétences
        function updateCompetenceLabel() {{

            const checks = document.querySelectorAll(".competence-check:checked");
            const btn = document.getElementById("competenceBtn");

            if (checks.length === 0) {{
                btn.innerText = "Sélectionner vos compétences";
                return;
            }}

            let values = Array.from(checks).map(c => c.value);

            btn.innerText = values.join(", ");
        }}

        // écoute checkbox
        document.querySelectorAll(".competence-check").forEach(cb => {{
            cb.addEventListener("change", updateCompetenceLabel);
        }});

    </script>

    </body>
    </html>
    """


    return HTMLResponse(content=html)





# =========================
# EDIT PAGE
# =========================
@app.get("/edit/{id}", response_class=HTMLResponse)
def edit(id: int):

    c = next((x for x in collaborateurs if x["id"] == id), None)

    if not c:
        return RedirectResponse("/", status_code=303)
    c["competence"] = normalize_competence(c["competence"])

    
    html = f"""
    <html>

    <head>

        <title>Modifier collaborateur</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"
        >

    </head>

    <body class="bg-light">

    <div class="container mt-4">

        <h2 class="mb-4">
            Modifier collaborateur
        </h2>

        <form
            class="card p-4"
            method="post"
            action="/update/{id}"
        >

            <div class="row mb-3">

                <div class="col">

                    <label class="form-label">
                        Nom
                    </label>

                    <input
                        class="form-control"
                        name="nom"
                        value="{c['nom']}"
                        required
                    >

                </div>

                <div class="col">

                    <label class="form-label">
                        Prénom
                    </label>

                    <input
                        class="form-control"
                        name="prenom"
                        value="{c['prenom']}"
                        required
                    >

                </div>

            </div>

            <div class="row mb-3">

                <div class="col">

                    <label class="form-label">
                        Profil
                    </label>

                    <select
                        class="form-control"
                        name="profil"
                        required
                    >

                        {"".join([
                            f'''
                            <option
                                value="{p}"
                                {"selected" if p == c["profil"] else ""}
                            >
                                {p}
                            </option>
                            '''
                            for p in PROFILS
                        ])}

                    </select>

                </div>

                <div class="col">

                    <label class="form-label">
                        Agence
                    </label>

                    <select
                        class="form-control"
                        name="agence"
                        required
                    >

                        {"".join([
                            f'''
                            <option
                                value="{a}"
                                {"selected" if a == c["agence"] else ""}
                            >
                                {a}
                            </option>
                            '''
                            for a in AGENCES
                        ])}

                    </select>

                </div>

            </div>

       

           
         <div class="mb-3">

            <label class="form-label">
                Compétences
            </label>

            <div class="dropdown w-100">

                <button class="form-control text-start dropdown-toggle"
                        type="button"
                        data-bs-toggle="dropdown"
                        id="competenceBtn">
                    Sélectionner compétences
                </button>

                <div class="dropdown-menu p-3 w-100"
                    style="max-height:250px; overflow:auto;">

                    {"".join([
                        f"<div class='fw-bold mt-2'>{g}</div>" +
                        "".join([
                            f"""
                            <div class="form-check">
                                <input class="form-check-input"
                                    type="checkbox"
                                    name="competence"
                                    value="{skill}"
                                    {"checked" if skill in c["competence"] else ""}>
                                <label class="form-check-label">{skill}</label>
                            </div>
                            """
                            for skill in skills
                        ])
                        for g, skills in COMPETENCES.items()
                    ])}

                </div>

            </div>

        </div>
            


            <div class="row mb-4">

                <div class="col">

                    <label class="form-label">
                        Niveau
                    </label>

                    <input
                        class="form-control"
                        name="niveau"
                        type="number"
                        min="0"
                        max="5"
                        value="{c['niveau']}"
                        required
                    >

                </div>

                <div class="col">

                    <label class="form-label">
                        Appétence
                    </label>

                    <input
                        class="form-control"
                        name="niveau_attendu"
                        type="number"
                        min="0"
                        max="5"
                        value="{c['niveau_attendu']}"
                        required
                    >

                </div>

            </div>

            <div class="d-flex gap-2">

                <button class="btn btn-success">
                    Sauvegarder
                </button>

                <a href="/"
                   class="btn btn-secondary">
                    Retour
                </a>

            </div>

        </form>

    </div>

    </body>
    </html>
    """

    return HTMLResponse(content=html)


# =========================
# UPDATE
# =========================
@app.post("/update/{id}")
def update(
    request: Request,
    id: int,
    nom: str = Form(...),
    prenom: str = Form(...),
    profil: str = Form(...),
    agence: str = Form(...),
    competence: Optional[Union[List[str], str]] = Form(None),
    niveau: int = Form(...),
    niveau_attendu: int = Form(...)
):

    user = get_current_user(request)

    if not user:
        raise HTTPException(status_code=401, detail="Non autorisé")

    competence = normalize_competence(competence)

    for c in collaborateurs:

        if c["id"] == id:

            c["nom"] = nom
            c["prenom"] = prenom
            c["profil"] = profil
            c["agence"] = agence
            c["competence"] = competence
            c["niveau"] = clamp(niveau)
            c["niveau_attendu"] = clamp(niveau_attendu)

            break

    log_action(user, "MODIFICATION", f"{prenom} {nom}")

    return RedirectResponse("/", status_code=303)


# =========================
# ANNULATION
# =========================
@app.get("/cancel")
def cancel(request: Request, action: str = "INCONNUE"):

    user = get_current_user(request)

    if not user:
        raise HTTPException(status_code=401, detail="Non autorisé")

    log_action(user, "ANNULATION", "Formulaire collaborateur abandonné")

    return RedirectResponse("/", status_code=303)




# =========================
# AUDIT LOG PAGE
# =========================
@app.get("/audit", response_class=HTMLResponse)
def audit_page():

    html = """
    <html>
    <head>
        <title>Audit Log</title>

        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet">
    </head>

    <body class="bg-light">

    <div class="container mt-4">

        <h2 class="mb-4">
            Audit Log
        </h2>

        <a href="/"
           class="btn btn-secondary mb-3">
           Retour
        </a>

        <table class="table table-bordered table-striped bg-white">

            <thead class="table-dark">
                <tr>
                    <th>Date</th>
                    <th>Utilisateur</th>
                    <th>Action</th>
                    <th>Détails</th>
                </tr>
            </thead>

            <tbody>
    """

    for log in reversed(audit_logs):

        html += f"""
        <tr>
            <td>{log['date']}</td>
            <td>{log['user']}</td>
            <td>{log['action']}</td>
            <td>{log['details']}</td>
        </tr>
        """

    html += """
            </tbody>

        </table>

    </div>

    </body>
    </html>
    """

    return HTMLResponse(content=html)



# =========================
# EXPORT EXCEL
# =========================
@app.get("/export/excel")
def export_excel():

    wb = Workbook()
    ws = wb.active

    ws.append([
        "Nom",
        "Prénom",
        "Profil",
        "Agence",
        "Compétence",
        "Niveau",
        "Appétence"
    ])

    for c in collaborateurs:

        ws.append([
            c["nom"],
            c["prenom"],
            c["profil"],
            c["agence"],
            ", ".join(c["competence"]),
            c["niveau"],
            c["niveau_attendu"]
        ])

    stream = BytesIO()

    wb.save(stream)

    stream.seek(0)

    return StreamingResponse(
        stream,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={
            "Content-Disposition":
            "attachment; filename=skills.xlsx"
        }
    )


# =========================
# EXPORT PDF
# =========================
@app.get("/export/pdf")
def export_pdf():

    buffer = BytesIO()

    pdf = canvas.Canvas(buffer, pagesize=A4)

    y = 800

    pdf.setFont("Helvetica", 10)

    for c in collaborateurs:

        pdf.drawString(
            50,
            y,
            f"{c['nom']} {c['prenom']} | "
            f"{c['profil']} | "
            f"{c['agence']} | "
            f"{', '.join(c['competence'])} | "
            f"N:{c['niveau']} | "
            f"A:{c['niveau_attendu']}"
        )

        y -= 20

    pdf.save()

    buffer.seek(0)

    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={
            "Content-Disposition":
            "attachment; filename=skills.pdf"
        }
    )