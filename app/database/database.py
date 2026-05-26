# # # from sqlalchemy import create_engine
# # # from sqlalchemy.ext.declarative import declarative_base
# # # from sqlalchemy.orm import sessionmaker


# # # DATABASE_URL = "sqlite:///./skills.db"

# # # engine = create_engine(
# # #     DATABASE_URL,
# # #     connect_args={"check_same_thread": False}
# # # )

# # # SessionLocal = sessionmaker(
# # #     autocommit=False,
# # #     autoflush=False,
# # #     bind=engine
# # # )

# # # Base = declarative_base()


# # from sqlalchemy import create_engine
# # from sqlalchemy.orm import sessionmaker

# # DATABASE_URL = "sqlite:///./skills.db"

# # engine = create_engine(
# #     DATABASE_URL,
# #     connect_args={"check_same_thread": False}
# # )

# # SessionLocal = sessionmaker(
# #     autocommit=False,
# #     autoflush=False,
# #     bind=engine
# # )



# import os
# from sqlalchemy import create_engine
# from sqlalchemy.orm import sessionmaker, declarative_base

# DATABASE_URL = os.getenv("DATABASE_URL")

# if not DATABASE_URL:
#     raise Exception(" DATABASE_URL n'est pas définie (Render ou local)")

# engine = create_engine(
#     DATABASE_URL,
#     connect_args={"sslmode": "require"}
# )

# SessionLocal = sessionmaker(
#     autocommit=False,
#     autoflush=False,
#     bind=engine
# )

# Base = declarative_base()





import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise Exception("DATABASE_URL n'est pas définie")

# 🔥 détection SQLite vs PostgreSQL
if DATABASE_URL.startswith("sqlite"):
    engine = create_engine(
        DATABASE_URL,
        connect_args={"check_same_thread": False}
    )
else:
    engine = create_engine(
        DATABASE_URL,
        pool_pre_ping=True
    )

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()