from fastapi import FastAPI, Form
from fastapi.responses import HTMLResponse, RedirectResponse, StreamingResponse
from io import BytesIO
from openpyxl import Workbook
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from typing import List, Union, Optional
from urllib.parse import quote


app = FastAPI()

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
        "Apache Nifi", "Angular 17", "Angular 19", "CSS", "HTML", "Hibernate", "Java 8", "Java 21", "Java 25", "Jasper report", "Javascript", 
        "Maven 3", "NPM/NodeJS", "Open Feign", "RGAA", "Spring", "Spring Batch", "SCSS", "Typescript 5"
    ],

    "Protocole": ["JSON","REST", "SOAP", "XML"],

    "Bases de données": ["Oracle", "Oracle SQL Developer", "PG Admin", "PostgreSQL"],

    "Devops/Infra": ["Apache", "Docker", "Docker Compose", "Docker Swarm", "Git", "Gitlab", "GitlabCI", "Helm", "Kubernetes", "kubctl", 
        "Linux Ubuntu", "Nginx""Scripts Shell", "Tomcat", "SonarQube"],

    "Tests": ["ArchUnit", "Cypress", "Castle Mock", "JUnit", "Mockito", "MockServer", "Postman", "Playwright", "Robotframework", "SoapUi", "Jasmine/Karma"],

    "Perf": ["Gatling", "Jmeter"]
}

AGENCES = ["Bordeaux", "Lyon", "Montpellier", "Nantes", "Niort", "Paris", "Rennes", "Toulouse"]

# =========================
# LEGENDES TOOLTIP
# =========================
LEG_NIVEAU = """
0 = Aucune notion
1 = Connaissances
2 = Travail supervisé
3 = Autonomie limitée
4 = Maîtrise et autonomie totale
5 = Maîtrise et enseignement"""

LEG_APPETENCE = """0 = Aversion
1 = Peu d'intérêt
2 = Curiosité
3 = Intéressé
4 = Très intéressé
5 = Vital"""

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
        "competence": "Java 21",
        "niveau": 4,
        "niveau_attendu": 5
    },
    {
        "id": 2,
        "nom": "Alice",
        "prenom": "Martin",
        "profil": "Développeur",
        "agence": "Lyon",
        "competence": "PostgreSQL",
        "niveau": 3,
        "niveau_attendu": 4
    }
]


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


# =========================
# AJOUTER UNE ROUTE BACKEND
# =========================
@app.get("/remove-competence/{id}")
def remove_competence(id: int, comp: str):

    for c in collaborateurs:
        if c["id"] == id:

            if isinstance(c["competence"], list):

                # règle métier : minimum 1 compétence
                if len(c["competence"]) <= 1:
                    return RedirectResponse("/?error=last_competence", status_code=303)

                c["competence"] = [x for x in c["competence"] if x != comp]

            break

    return RedirectResponse("/", status_code=303)


# =========================
# HOME
# =========================
@app.get("/", response_class=HTMLResponse)
# def home(agence: str = None, competence: str = None, search: str = None, profil: str = None):
def home(agence: str = None, competence: str = None, search: str = None, profil: str = None, error: str = None):

    data = collaborateurs

    if agence:
        data = [c for c in data if c["agence"] == agence]

    if competence:
        # data = [c for c in data if c["competence"] == competence]
        data = [c for c in data if competence in c["competence"]]

    if search:
        data = [c for c in data if search.lower() in c["nom"].lower() or search.lower() in c["prenom"].lower()]

    if profil:
        data = [c for c in data if c["profil"] == profil]

    total = len(data)
    avg = round(sum(c["niveau"] for c in data) / total, 1) if total else 0

    html = f"""
    <html>
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <title>Skills Matrix</title>
        <style>
            .required-star {{
                color: red;
                margin-left: 3px;
            }}

            .is-invalid {{
                border: 1px solid #dc3545 !important;
                box-shadow: 0 0 0 0.15rem rgba(220,53,69,.25);
            }}

        </style>
    </head>

    <body class="bg-light">
    <div class="container mt-4">

        <h2>Skills Matrix</h2>

        <div class="alert alert-info">
            Survoler les champs pour voir les légendes niveau / appétence.
        </div>

        <div class="row mb-3">
            <div class="col card p-3 m-2">Total: {total}</div>
            <div class="col card p-3 m-2">Moyenne: {avg}</div>
        </div>

        <div class="mb-3">
            <a href="/export/excel" class="btn btn-dark">Excel</a>
            <a href="/export/pdf" class="btn btn-danger">PDF</a>
        </div>

        <!-- ADD -->
        <form class="card p-3 mb-3" action="/add" method="post">

            <div class="row">
                <div class="col"><input class="form-control" name="nom" placeholder="Nom" required></div>
                <div class="col"><input class="form-control" name="prenom" placeholder="Prénom" required></div>

                <div class="col">
                    <select class="form-control" name="profil" required>
                        <option value="">Profil</option>
                        {"".join([f'<option value="{p}">{p}</option>' for p in PROFILS])}
                    </select>
                </div>

                <div class="col">
                    <select class="form-control" name="agence" required>
                        <option value="">Agence</option>
                        {"".join([f'<option value="{a}">{a}</option>' for a in AGENCES])}
                    </select>
                </div>
            </div>

            <div class="row mt-2">

                <div class="col">
                    <select class="form-control" name="competence" required>
                        <option value="">Compétence</option>
                        {"".join([
                            f'<optgroup label="{g}">{"".join([f"<option value={s}>{s}</option>" for s in skills])}</optgroup>'
                            for g, skills in COMPETENCES.items()
                        ])}
                    </select>
                </div>

                <div class="col">
                    <input class="form-control" name="niveau" type="number"
                        min="0" max="5" placeholder="Niveau"
                        title="{LEG_NIVEAU}" required>
                </div>

                <div class="col">
                    <input class="form-control" name="niveau_attendu" type="number"
                        min="0" max="5" placeholder="Appétence"
                        title="{LEG_APPETENCE}" required>
                </div>

                <div class="col">
                    <button class="btn btn-primary w-100">Ajouter</button>
                </div>
            </div>
        </form>

        <!-- FILTERS -->
        <form class="card p-3 mb-3" method="get">

            <div class="row">

                <div class="col"><input class="form-control" name="search" placeholder="Nom / Prénom"></div>

                <div class="col">
                    <select class="form-control" name="profil">
                        <option value="">Profil</option>
                        {"".join([f'<option value="{p}">{p}</option>' for p in PROFILS])}
                    </select>
                </div>

                <div class="col">
                    <select class="form-control" name="agence">
                        <option value="">Agence</option>
                        {"".join([f'<option value="{a}">{a}</option>' for a in AGENCES])}
                    </select>
                </div>

                <div class="col">
                    <select class="form-control" name="competence">
                        <option value="">Compétence</option>
                        {"".join([
                            f'<optgroup label="{g}">{"".join([f"<option value={s}>{s}</option>" for s in skills])}</optgroup>'
                            for g, skills in COMPETENCES.items()
                        ])}
                    </select>
                </div>

                <div class="col"><button class="btn btn-success w-100">Filtrer</button></div>
                <div class="col"><a href="/" class="btn btn-secondary w-100">Reset</a></div>

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
                    <th>Compétence</th>
                    <th>Niveau</th>
                    <th>Appétence</th>
                    <th>Actions</th>
                </tr>
            </thead>
    """


######
    for c in data:
        html += f"""
        <tr>
            <td>{c['nom']}</td>
            <td>{c['prenom']}</td>
            <td>{c['profil']}</td>
            <td>{c['agence']}</td>
<!--  
         <td>{c['competence']}</td>  
            <td>{", ".join(c['competence'])}</td>   
            <td>
                {" ".join([
                    f'<span class="badge rounded-pill bg-primary me-1 mb-1" style="font-size:12px;">'
                    f'{comp} ✕</span>'
                    for comp in c["competence"]
                ])}
            </td> 

            <td>
                {" ".join([
                    f'''
                    <a href="/remove-competence/{c['id']}?comp={quote(comp)}"
                    style="
                            display:inline-block;
                            padding:4px 10px;
                            margin:2px;
                            background:#0d6efd;
                            color:white;
                            border-radius:20px;
                            font-size:12px;
                            text-decoration:none;">
                        {comp} ✕
                    </a>
                    '''
                    for comp in c["competence"]
                ])}
            </td>  

            <td>
                {" ".join([
                    f'''
                    <span class="badge bg-primary me-1 mb-1" style="font-size:12px; cursor:pointer;"
                        onclick="confirmDelete({c['id']}, '{comp}')">
                        {comp} ✕
                    </span>
                    '''
                    for comp in c["competence"]
                ])}
            </td>
        

            <td>
                <a href="/edit/{c['id']}" class="btn btn-warning btn-sm">✏️</a>

                <a href="/delete/{c['id']}"
                    class="btn btn-danger btn-sm"
                    onclick="return confirm('Voulez-vous vraiment supprimer ce collaborateur ?');">
                    🗑
                </a>
            </td>

            <td>
                {" ".join([
                    f'''
                    <span class="badge bg-primary me-1 mb-1" style="font-size:12px; cursor:pointer;"
                        onclick="confirmDelete({c['id']}, '{comp}')">
                        {comp} ✕
                    </span>
                    '''
                    for comp in c["competence"]
                ])}
            </td>

-->

            <td>
                {" ".join([
                    f'''
                    <span class="badge bg-primary me-1 mb-1" style="font-size:12px; cursor:pointer;"
                        onclick="confirmDelete({c['id']}, '{comp}')">
                        {comp} ✕
                    </span>
                    '''
                    for comp in c["competence"]
                ])}
            </td> 


            <td>{c['niveau']}</td>
            <td>{c['niveau_attendu']}</td>
            <td>
                <a href="/edit/{c['id']}" class="btn btn-warning btn-sm">✏️</a>
                <a href="/delete/{c['id']}"
                    class="btn btn-danger btn-sm"
                    onclick="return confirm('Voulez-vous vraiment supprimer ce collaborateur ?');">
                    🗑
                </a>
            </td>
        </tr>
        """
        


        {"""
        <div class="modal fade show" id="infoModal" tabindex="-1" style="display:block;" aria-modal="true" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">Information</h5>
                    </div>

                    <div class="modal-body">
                        Ce collaborateur doit conserver au moins une compétence.
                    </div>

                    <div class="modal-footer">
                        <a href="/" class="btn btn-primary">OK</a>
                    </div>

                </div>
            </div>
        </div>
        """ if error == "last_competence" else ""}
    
    
    # =========================
    # SCRIPT DELETE SAFE CHECK
    # =========================
    
    html += """
<script>

function confirmDelete(event, nbCompetences) {

    // sécurité conversion nombre
    nbCompetences = parseInt(nbCompetences);

    // minimum 1 compétence obligatoire
    if (nbCompetences <= 1) {

        event.preventDefault();

        alert(
            "Impossible de supprimer ce collaborateur.\n\n" +
            "Le collaborateur doit conserver au moins une compétence."
        );

        return false;
    }

    // confirmation suppression
    const confirmDelete = confirm(
        "Voulez-vous vraiment supprimer ce collaborateur ?"
    );

    if (!confirmDelete) {

        event.preventDefault();

        return false;
    }

    return true;
}

</script>
    """

    html += "</table></div></body></html>"

    return html



# =========================
# ADD
# =========================
@app.post("/add")
def add(
    nom: str = Form(...),
    prenom: str = Form(...),
    profil: str = Form(...),
    agence: str = Form(...),
    competence: Optional[Union[List[str], str]] = Form(None),
    niveau: int = Form(...),
    niveau_attendu: int = Form(...)
):

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

    return RedirectResponse("/", status_code=303)


# =========================
# DELETE
# =========================
# @app.get("/delete/{id}")
# def delete(id: int):
#     global collaborateurs
#     collaborateurs = [c for c in collaborateurs if c["id"] != id]
#     return RedirectResponse("/", status_code=303)

@app.get("/delete/{id}")
def delete(id: int):

    global collaborateurs

    collab = next((c for c in collaborateurs if c["id"] == id), None)

    if not collab:
        return RedirectResponse("/", status_code=303)

    competences = collab["competence"]

    if isinstance(competences, str):
        competences = [competences]

    # règle métier
    if len(competences) <= 1:

        return RedirectResponse(
            "/?error=last_competence",
            status_code=303
        )

    collaborateurs = [
        c for c in collaborateurs
        if c["id"] != id
    ]

    return RedirectResponse("/", status_code=303)


# =========================
# EDIT PAGE
# =========================
@app.get("/edit/{id}", response_class=HTMLResponse)
def edit(id: int):

    c = next((x for x in collaborateurs if x["id"] == id), None)
    if not c:
        return RedirectResponse("/")

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

                    <div class="dropdown w-100">

                        <button class="form-control text-start dropdown-toggle"
                                type="button"
                                data-bs-toggle="dropdown"
                                id="competenceBtn">
                            Sélectionner compétences
                        </button>

                        <div class="dropdown-menu p-3 w-100" style="max-height:250px; overflow:auto;">

                            {''.join([
                                f"<div class='fw-bold mt-2'>{g}</div>" +
                                ''.join([
                                    f"""
                                    <div class="form-check">
                                        <input class="form-check-input competence-check"
                                            type="checkbox"
                                            name="competence"
                                            value="{s}">
                                        <label class="form-check-label">{s}</label>
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
                btn.innerText = "Sélectionner compétences";
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
# UPDATE
# =========================
@app.post("/update/{id}")
def update(
    id: int,
    nom: str = Form(...),
    prenom: str = Form(...),
    profil: str = Form(...),
    agence: str = Form(...),
    competence: Optional[Union[List[str], str]] = Form(None),
    niveau: int = Form(...),
    niveau_attendu: int = Form(...)
):

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

    return RedirectResponse("/", status_code=303)


# =========================
# EXPORT EXCEL
# =========================
@app.get("/export/excel")
def export_excel():

    wb = Workbook()
    ws = wb.active
    ws.append(["Nom", "Prénom", "Profil", "Agence", "Compétence", "Niveau", "Appétence"])

    for c in collaborateurs:
        ws.append([c["nom"], c["prenom"], c["profil"], c["agence"],
                   c["competence"], c["niveau"], c["niveau_attendu"]])

    stream = BytesIO()
    wb.save(stream)
    stream.seek(0)

    return StreamingResponse(stream,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": "attachment; filename=skills.xlsx"}
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
            f"{c['nom']} {c['prenom']} | {c['profil']} | {c['agence']} | {c['competence']} | N:{c['niveau']} | A:{c['niveau_attendu']}"
        )
        y -= 20

    pdf.save()
    buffer.seek(0)

    return StreamingResponse(buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": "attachment; filename=skills.pdf"}
    )