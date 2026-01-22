FROM frappe/erpnext:v15

USER frappe
WORKDIR /home/frappe/frappe-bench

# Expose port
EXPOSE 8000

# Start Frappe (we'll create site later via shell)
CMD ["bench", "start"]
