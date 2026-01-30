import frappe

def execute():
	"""
	Update app_name to HRMatrix in System Settings and Website Settings.
	This ensures the rebranding is applied even if database settings are empty or set to Frappe.
	"""
	frappe.db.set_single_value("System Settings", "app_name", "HRMatrix")
	frappe.db.set_single_value("Website Settings", "app_name", "HRMatrix")
