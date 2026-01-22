FROM frappe/erpnext:v15

WORKDIR /home/frappe/frappe-bench

EXPOSE 8000

CMD ["bench", "start"]
