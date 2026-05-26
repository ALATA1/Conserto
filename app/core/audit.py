# from datetime import datetime

# audit_logs = []

# def log_action(user, action, details):
#     audit_logs.append({
#         "date": datetime.now().strftime("%d/%m/%Y %H:%M:%S"),
#         "user": user["username"],
#         "action": action,
#         "details": details
#     })




# app/core/audit.py

from datetime import datetime
from typing import List, Dict, Any

audit_logs: List[Dict[str, Any]] = []

def log_action(user, action: str, details: str):
    audit_logs.append({
        "timestamp": datetime.utcnow().isoformat(),
        "user": user["username"] if user else "anonymous",
        "action": action,
        "details": details
    })