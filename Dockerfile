# Stage 1: Build frontend
FROM node:22-slim AS frontend-build
WORKDIR /app/frontend
COPY app/frontend/package.json app/frontend/package-lock.json ./
RUN npm ci
COPY app/frontend/ ./
RUN npm run build

# Stage 2: Python runtime
FROM python:3.13-slim
WORKDIR /app

# Install pipenv
RUN pip install --no-cache-dir pipenv

# Install Python dependencies
COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --system

# Copy application code
COPY app/ ./app/
COPY .env* ./

# Seed data: stored separately so the volume mount doesn't hide it
COPY database/ ./database-seed/

# Copy built frontend from stage 1
COPY --from=frontend-build /app/frontend/dist ./app/frontend/dist

# Entrypoint script to seed the volume on first deploy
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

# Railway provides PORT env var
ENV PORT=8000
EXPOSE ${PORT}

ENTRYPOINT ["./entrypoint.sh"]
CMD ["python", "-m", "app.main"]
