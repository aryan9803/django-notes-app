FROM python:3.9

WORKDIR /app/backend

COPY requirements.txt /app/backend

# Install build dependencies, cleanup, and install python dependencies
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    # Install Python dependencies
    && pip install mysqlclient \
    && pip install --no-cache-dir -r requirements.txt \
    # Cleanup to reduce image size
    && apt-get remove --purge -y gcc default-libmysqlclient-dev pkg-config \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /app/backend

EXPOSE 8000

# ⭐️ CRITICAL FIX: Add the CMD instruction to start the Django server ⭐️
# The 0.0.0.0 is essential to listen on all interfaces.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
