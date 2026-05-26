from fastapi import FastAPI, Form, Depends
from fastapi.responses import HTMLResponse, RedirectResponse, StreamingResponse
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import declarative_base, sessionmaker, Session
from io import BytesIO
from openpyxl import Workbook
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from typing import List, Union, Optional

# =========================================================
# APP
# =========================================================
app = FastAPI()

# =========================================================
# SQLITE
# =========================================================
DATABASE_URL = "sqlite:///./skills.db"

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()

# =========================================================
# MODEL
# =========================================================
class Collaborateur(Base):

    __tablename__ = "collaborateurs"

    id = Column(Integer, primary_key=True, index=True)

    nom = Column(String, nullable=False)
    prenom = Column(String, nullable=False)

    profil = Column(String, nullable=False)

    agence = Column(String, nullable=False)

    competence = Column(String, nullable=False)

    niveau = Column(Integer, nullable=False)

    niveau_attendu = Column(Integer, nullable=False)

# =========================================================
# CREATE DB
# =========================================================
Base.metadata.create_all(bind=engine)

# =========================================================
# DB SESSION
# =========================================================
def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()

# =========================================================
# PROFILS
# =========================================================
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

# =========================================================
# COMPETENCES
# =========================================================
COMPETENCES = {
    "Langages": [
        "Apache Nifi",
        "Angular 17",
        "Angular 19",
        "CSS",
        "HTML",
        "Hibernate",
        "Java 8",
        "Java 21",
        "Java 25",
        "Jasper report",
        "Javascript",
        "Maven 3",
        "NPM/NodeJS",
        "Open Feign",
        "RGAA",
        "Spring",
        "Spring Batch",
        "SCSS",
        "Typescript 5"
    ],

    "Protocole": [
        "JSON",
        "REST",
        "SOAP",
        "XML"
    ],

    "Bases de données": [
        "Oracle",
        "Oracle SQL Developer",
        "PG Admin",
        "PostgreSQL"
    ],

    "Devops/Infra": [
        "Apache",
        "Docker",
        "Docker Compose",
        "Docker Swarm",
        "Git",
        "Gitlab",
        "GitlabCI",
        "Helm",
        "Kubernetes",
        "kubctl",
        "Linux Ubuntu",
        "Nginx",
        "Scripts Shell",
        "Tomcat",
        "SonarQube"
    ],

    "Tests": [
        "ArchUnit",
        "Cypress",
        "Castle Mock",
        "JUnit",
        "Mockito",
        "MockServer",
        "Postman",
        "Playwright",
        "Robotframework",
        "SoapUi",
        "Jasmine/Karma"
    ],

    "Perf": [
        "Gatling",
        "Jmeter"
    ]
}

# =========================================================
# AGENCES
# =========================================================
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

# =========================================================
# LEGENDES
# =========================================================
LEG_NIVEAU = """
0 = Pas de notion
1 = Notions de base
2 = Débutant opérationnel
3 = Autonome
4 = Confirmé
5 = Expert / Référent
"""

# =========================================================
# HELPERS
# =========================================================
def normalize_competence(value):

    if not value:
        return []

    if isinstance(value, list):
        return value

    return [value]

def clamp(v):
    return max(0, min(5, int(v)))

# =========================================================
# HOME
# =========================================================
@app.get("/", response_class=HTMLResponse)
def home(
    db: Session = Depends(get_db)
):

    collaborateurs = db.query(Collaborateur).all()

    total = len(collaborateurs)

    avg = round(
        sum(c.niveau for c in collaborateurs) / total,
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
                background:#f5f6fa;
            }}

            .skill-badge {{
                cursor:pointer;
                font-size:12px;
            }}

            .table td {{
                vertical-align:middle;
            }}

        </style>

    </head>

    <body>

    <div class="container mt-4">

        <h2 class="mb-4">
            Skills Matrix
        </h2>

        <div class="alert alert-info">

            <b>Échelle de notation : Survoler les champs niveau et appétence pour voir les légendes.</b>

            

        </div>

        <div class="row mb-4">

            <div class="col card p-3 m-2">
                Total collaborateurs : {total}
            </div>

            <div class="col card p-3 m-2">
                Moyenne niveau : {avg}
            </div>

        </div>

        <!-- EXPORT -->

        <div class="mb-4">

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

        <form
            class="card p-4 mb-4"
            method="post"
            action="/add"
        >

            <div class="row mb-3">

                <div class="col">

                    <input
                        class="form-control"
                        name="nom"
                        placeholder="Nom"
                        required
                    >

                </div>

                <div class="col">

                    <input
                        class="form-control"
                        name="prenom"
                        placeholder="Prénom"
                        required
                    >

                </div>

                <div class="col">

                    <select
                        class="form-control"
                        name="agence"
                        required
                    >

                        <option value="">
                            Agence
                        </option>

                        {"".join([
                            f'<option value="{a}">{a}</option>'
                            for a in AGENCES
                        ])}

                    </select>

                </div>

            </div>

            <div class="row mb-3">

                <div class="col">

                    <select
                        class="form-control"
                        name="profil"
                        required
                    >

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

                    <div class="dropdown w-100">

                        <button
                            class="form-control text-start dropdown-toggle"
                            type="button"
                            data-bs-toggle="dropdown"
                            id="competenceBtn"
                        >
                            Compétences
                        </button>

                        <div
                            class="dropdown-menu p-3 w-100"
                            style="max-height:250px; overflow:auto;"
                        >

                            {''.join([
                                f"<div class='fw-bold mt-2'>{g}</div>" +
                                ''.join([
                                    f'''
                                    <div class="form-check">

                                        <input
                                            class="form-check-input competence-check"
                                            type="checkbox"
                                            name="competence"
                                            value="{s}"
                                        >

                                        <label class="form-check-label">
                                            {s}
                                        </label>

                                    </div>
                                    '''
                                    for s in skills
                                ])
                                for g, skills in COMPETENCES.items()
                            ])}

                        </div>

                    </div>

                </div>

                <div class="col">

                    <input
                        class="form-control"
                        name="niveau"
                        type="number"
                        min="0"
                        max="5"
                        placeholder="Niveau"
                        title="{LEG_NIVEAU}"
                        required
                    >

                </div>

                <div class="col">

                    <input
                        class="form-control"
                        name="niveau_attendu"
                        type="number"
                        min="0"
                        max="5"
                        placeholder="Appétence"
                        title="{LEG_NIVEAU}"
                        required
                    >

                </div>

                <div class="col">

                    <button class="btn btn-primary w-100">
                        Ajouter
                    </button>

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

        <table class="table table-bordered table-striped bg-white">

            <thead class="table-dark">

                <tr>

                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Agence</th>
                    <th>Compétences</th>
                    <th>Niveau</th>
                    <th>Niveau attendu</th>
                    <th>Actions</th>

                </tr>

            </thead>

            <tbody>
    """

    for c in collaborateurs:

        competences = c.competence.split(",")

        competences_html = ""

        for comp in competences:

            competences_html += f"""
            <span
                class="badge bg-primary me-1 mb-1 skill-badge"
                onclick="deleteCompetence(
                    {c.id},
                    '{comp}'
                )"
            >
                {comp} ✕
            </span>
            """

        html += f"""
        <tr>

            <td>{c.nom}</td>

            <td>{c.prenom}</td>

            <td>{c.agence}</td>

            <td>
                {competences_html}
            </td>

            <td>{c.niveau}</td>

            <td>{c.niveau_attendu}</td>

            <td>

                <a
                    href="/edit/{c.id}"
                    class="btn btn-warning btn-sm"
                >
                    ✏️
                </a>

                <a
                    href="/delete/{c.id}"
                    class="btn btn-danger btn-sm"
                >
                    🗑
                </a>

            </td>

        </tr>
        """

    html += """
            </tbody>

        </table>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>

        function deleteCompetence(id, competence) {

            if (
                confirm(
                    "Supprimer la compétence : " +
                    competence +
                    " ?"
                )
            ) {

                window.location.href =
                    "/remove-competence/" +
                    id +
                    "?comp=" +
                    encodeURIComponent(competence);

            }
        }

        // UPDATE LABEL
        function updateCompetenceLabel() {

            const checks =
                document.querySelectorAll(
                    ".competence-check:checked"
                );

            const btn =
                document.getElementById(
                    "competenceBtn"
                );

            if (checks.length === 0) {

                btn.innerText = "Compétences";

                return;
            }

            let values =
                Array.from(checks)
                .map(c => c.value);

            btn.innerText = values.join(", ");
        }

        document
            .querySelectorAll(".competence-check")
            .forEach(cb => {

                cb.addEventListener(
                    "change",
                    updateCompetenceLabel
                );

            });

    </script>

    </body>

    </html>
    """

    return HTMLResponse(content=html)

# =========================================================
# ADD
# =========================================================
@app.post("/add")
def add(
    nom: str = Form(...),
    prenom: str = Form(...),
    profil: str = Form(...),
    agence: str = Form(...),
    competence: Optional[Union[List[str], str]] = Form(None),
    niveau: int = Form(...),
    niveau_attendu: int = Form(...),
    db: Session = Depends(get_db)
):

    competence = normalize_competence(competence)

    new_collab = Collaborateur(

        nom=nom,
        prenom=prenom,

        profil=profil,

        agence=agence,

        competence=",".join(competence),

        niveau=clamp(niveau),

        niveau_attendu=clamp(niveau_attendu)
    )

    db.add(new_collab)

    db.commit()

    db.refresh(new_collab)

    return RedirectResponse("/", status_code=303)

# =========================================================
# DELETE COMPETENCE
# =========================================================
@app.get("/remove-competence/{id}")
def remove_competence(
    id: int,
    comp: str,
    db: Session = Depends(get_db)
):

    collab = db.query(Collaborateur).filter(
        Collaborateur.id == id
    ).first()

    if not collab:
        return RedirectResponse("/", status_code=303)

    competences = collab.competence.split(",")

    if len(competences) <= 1:
        return RedirectResponse("/", status_code=303)

    competences = [
        c for c in competences
        if c != comp
    ]

    collab.competence = ",".join(competences)

    db.commit()

    return RedirectResponse("/", status_code=303)

# =========================================================
# DELETE COLLAB
# =========================================================
@app.get("/delete/{id}")
def delete(
    id: int,
    db: Session = Depends(get_db)
):

    collab = db.query(Collaborateur).filter(
        Collaborateur.id == id
    ).first()

    if collab:

        db.delete(collab)

        db.commit()

    return RedirectResponse("/", status_code=303)

# =========================================================
# EDIT
# =========================================================
@app.get("/edit/{id}", response_class=HTMLResponse)
def edit(
    id: int,
    db: Session = Depends(get_db)
):

    c = db.query(Collaborateur).filter(
        Collaborateur.id == id
    ).first()

    if not c:
        return RedirectResponse("/", status_code=303)

    competences = c.competence.split(",")

    html = f"""
    <html>

    <head>

        <title>Edit</title>

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

                    <input
                        class="form-control"
                        name="nom"
                        value="{c.nom}"
                        required
                    >

                </div>

                <div class="col">

                    <input
                        class="form-control"
                        name="prenom"
                        value="{c.prenom}"
                        required
                    >

                </div>

            </div>

            <div class="row mb-3">

                <div class="col">

                    <select
                        class="form-control"
                        name="agence"
                        required
                    >

                        {"".join([
                            f'''
                            <option
                                value="{a}"
                                {"selected" if a == c.agence else ""}
                            >
                                {a}
                            </option>
                            '''
                            for a in AGENCES
                        ])}

                    </select>

                </div>

                <div class="col">

                    <select
                        class="form-control"
                        name="profil"
                        required
                    >

                        {"".join([
                            f'''
                            <option
                                value="{p}"
                                {"selected" if p == c.profil else ""}
                            >
                                {p}
                            </option>
                            '''
                            for p in PROFILS
                        ])}

                    </select>

                </div>

            </div>

            <div class="mb-3">

                <div class="dropdown w-100">

                    <button
                        class="form-control text-start dropdown-toggle"
                        type="button"
                        data-bs-toggle="dropdown"
                    >
                        Compétences
                    </button>

                    <div
                        class="dropdown-menu p-3 w-100"
                        style="max-height:250px; overflow:auto;"
                    >

                        {"".join([
                            f"<div class='fw-bold mt-2'>{g}</div>" +
                            ''.join([
                                f'''
                                <div class="form-check">

                                    <input
                                        class="form-check-input"
                                        type="checkbox"
                                        name="competence"
                                        value="{s}"
                                        {"checked" if s in competences else ""}
                                    >

                                    <label class="form-check-label">
                                        {s}
                                    </label>

                                </div>
                                '''
                                for s in skills
                            ])
                            for g, skills in COMPETENCES.items()
                        ])}

                    </div>

                </div>

            </div>

            <div class="row mb-4">

                <div class="col">

                    <input
                        class="form-control"
                        name="niveau"
                        type="number"
                        min="0"
                        max="5"
                        value="{c.niveau}"
                        required
                    >

                </div>

                <div class="col">

                    <input
                        class="form-control"
                        name="niveau_attendu"
                        type="number"
                        min="0"
                        max="5"
                        value="{c.niveau_attendu}"
                        required
                    >

                </div>

            </div>

            <button class="btn btn-success">
                Sauvegarder
            </button>

        </form>

    </div>

    </body>

    </html>
    """

    return HTMLResponse(content=html)

# =========================================================
# UPDATE
# =========================================================
@app.post("/update/{id}")
def update(
    id: int,
    nom: str = Form(...),
    prenom: str = Form(...),
    profil: str = Form(...),
    agence: str = Form(...),
    competence: Optional[Union[List[str], str]] = Form(None),
    niveau: int = Form(...),
    niveau_attendu: int = Form(...),
    db: Session = Depends(get_db)
):

    collab = db.query(Collaborateur).filter(
        Collaborateur.id == id
    ).first()

    if collab:

        competence = normalize_competence(competence)

        collab.nom = nom
        collab.prenom = prenom
        collab.profil = profil
        collab.agence = agence

        collab.competence = ",".join(competence)

        collab.niveau = clamp(niveau)

        collab.niveau_attendu = clamp(
            niveau_attendu
        )

        db.commit()

    return RedirectResponse("/", status_code=303)

# =========================================================
# EXPORT EXCEL
# =========================================================
@app.get("/export/excel")
def export_excel(
    db: Session = Depends(get_db)
):

    collaborateurs = db.query(Collaborateur).all()

    wb = Workbook()

    ws = wb.active

    ws.title = "Skills Matrix"

    ws.append([
        "Nom",
        "Prénom",
        "Agence",
        "Compétences",
        "Niveau",
        "Niveau attendu"
    ])

    for c in collaborateurs:

        ws.append([
            c.nom,
            c.prenom,
            c.agence,
            c.competence,
            c.niveau,
            c.niveau_attendu
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

# =========================================================
# EXPORT PDF
# =========================================================
@app.get("/export/pdf")
def export_pdf(
    db: Session = Depends(get_db)
):

    collaborateurs = db.query(Collaborateur).all()

    buffer = BytesIO()

    pdf = canvas.Canvas(buffer, pagesize=A4)

    y = 800

    pdf.setFont("Helvetica", 10)

    for c in collaborateurs:

        pdf.drawString(
            50,
            y,
            f"{c.nom} {c.prenom} | "
            f"{c.agence} | "
            f"{c.competence} | "
            f"N:{c.niveau} | "
            f"NA:{c.niveau_attendu}"
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