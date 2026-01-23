FROM frappe/erpnext:v15

# Install PostgreSQL client for database connection checking
USER root
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*
USER frappe

WORKDIR /home/frappe/frappe-bench

# Copy startup script
COPY start.sh /home/frappe/frappe-bench/start.sh
RUN chmod +x /home/frappe/frappe-bench/start.sh

EXPOSE 8000

# Use startup script instead of direct bench serve
CMD ["/home/frappe/frappe-bench/start.sh"]
