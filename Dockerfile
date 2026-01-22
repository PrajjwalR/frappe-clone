FROM frappe/bench:latest
USER frappe
WORKDIR /home/frappe/frappe-bench
# Install Frappe and ERPNext
RUN bench init --skip-redis-config-generation --frappe-branch version-15 frappe-bench && \
    cd frappe-bench && \
    bench get-app --branch version-15 erpnext
WORKDIR /home/frappe/frappe-bench
# We'll create the site via Railway shell after deployment
EXPOSE 8000
# Use production server
CMD ["gunicorn", "-b", "0.0.0.0:8000", "frappe.app:application", "--timeout", "120", "--workers", "2"]
