from starlette.middleware.base import BaseHTTPMiddleware
import time

class AuditMiddleware(BaseHTTPMiddleware):

    async def dispatch(self, request, call_next):
        start = time.time()

        response = await call_next(request)

        duration = time.time() - start
        print(f"[AUDIT] {request.method} {request.url} - {duration:.2f}s")

        return response