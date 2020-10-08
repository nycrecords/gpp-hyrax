# A list of approved email domains that can login using NYC.ID IdP (not NYC Employees) credentials
APPROVED_NYCID_DOMAINS = ENV.fetch('APPROVED_DOMAINS', "").split(",")
