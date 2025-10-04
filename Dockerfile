# Utiliser une image Python officielle comme base
FROM python:3.13.2-slim

# Définir les variables d'environnement
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Créer et définir le répertoire de travail
WORKDIR /app

## Installer les dépendances système
#RUN apt-get update && apt-get install -y \
#    gcc \
#    postgresql-client \
#    libpq-dev \
#    gettext \
#    curl \
#    && rm -rf /var/lib/apt/lists/*

# Mettre à jour pip
RUN pip install --upgrade pip

# Copier tout le projet
COPY . /app/

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Créer un utilisateur non-root pour exécuter l'application
RUN useradd -m -u 1000 django && \
    chown -R django:django /app

# Collecter les fichiers statiques
RUN python manage.py collectstatic --noinput || true

# Changer vers l'utilisateur non-root
USER django

# Exposer le port
EXPOSE 8000

# Commande par défaut pour démarrer l'application avec Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120", "pipeline_test.wsgi:application"]