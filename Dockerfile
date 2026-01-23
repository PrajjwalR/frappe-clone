FROM frappe/erpnext:v15

# Install PostgreSQL client for database connection checking
USER root
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# PATCH: Comment out DROP DATABASE line to avoid cloud platform connection issues
RUN sed -i 's/^\troot_conn.sql(f.*DROP DATABASE.*/\t# PATCHED: DROP DATABASE commented out for cloud deployment/' \
    /home/frappe/frappe-bench/apps/frappe/frappe/database/postgres/setup_db.py

WORKDIR /home/frappe/frappe-bench

# Copy startup script with executable permissions
COPY --chmod=755 start.sh /home/frappe/frappe-bench/start.sh

# Switch to frappe user
USER frappe

EXPOSE 8000

# Use startup script instead of direct bench serve
CMD ["/home/frappe/frappe-bench/start.sh"]
