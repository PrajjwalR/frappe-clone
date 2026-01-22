FROM frappe/erpnext:v15
WORKDIR /home/frappe/frappe-bench
COPY --chown=frappe:frappe . .
EXPOSE 8000
CMD ["bench", "start"]
