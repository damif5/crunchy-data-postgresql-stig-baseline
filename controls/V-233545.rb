# encoding: UTF-8

control	'V-233545' do
	title	"PostgreSQL must utilize centralized management of the content captured in audit records generated by 
	all components of PostgreSQL."
	desc	"Without the ability to centrally manage the content captured in the audit records, identification, 
	troubleshooting, and correlation of suspicious behavior would be difficult and could lead to a delayed or 
	incomplete analysis of an ongoing attack.

The content captured in audit records must be managed from a central location (necessitating automation). 
Centralized management of audit records and logs provides for efficiency in maintenance and management of records, 
as well as the backup and archiving of those records. 

PostgreSQL may write audit records to database tables, to files in the file system, to other kinds of local 
repository, or directly to a centralized log management system. Whatever the method used, it must be compatible 
with off-loading the records to the centralized system."
	desc	'rationale', ''
	desc	'check', "On UNIX systems, PostgreSQL can be configured to use stderr, csvlog and syslog. To send logs 
	to a centralized location, syslog should be used.

As the database owner (shown here as \"postgres\"), ensure PostgreSQL uses syslog by running the following SQL:

$ sudo su - postgres
$ psql -c \"SHOW log_destination\"

As the database owner (shown here as \"postgres\"), check to which log facility PostgreSQL is configured by running 
the following SQL:

$ sudo su - postgres
$ psql -c \"SHOW syslog_facility\"

Check with the organization to see how syslog facilities are defined in their organization.

If PostgreSQL audit records are not written directly to or systematically transferred to a centralized log 
management system, this is a finding."
	desc	'fix', "Note: The following instructions use the PGDATA and PGVER environment variables. See 
	supplementary content APPENDIX-F for instructions on configuring PGDATA and APPENDIX-H for PGVER. 

To ensure logging is enabled, review supplementary content APPENDIX-C for instructions on enabling logging.

With logging enabled, as the database owner (shown here as \"postgres\"), configure the following parameters in 
postgresql.conf:

Note: Consult the organization on how syslog facilities are defined in the syslog daemon configuration.

$ sudo su - postgres
$ vi ${PGDATA?}/postgresql.conf
log_destination = 'syslog'
syslog_facility = 'LOCAL0'
syslog_ident = 'postgres'

Now, as the system administrator, reload the server with the new configuration:

$ sudo systemctl reload postgresql-${PGVER?}"
	impact 0.5
	tag severity: 'medium'
  tag gtitle: 'SRG-APP-000356-DB-000314'
  tag gid: 'V-233545'
  tag rid: 'SV-233545r617333_rule'
  tag stig_id: 'CD12-00-003800'
  tag fix_id: 'F-36704r606859_fix'
  tag cci: ["CCI-001844"]
  tag nist: ["AU-3 (2)"]

pg_ver = input('pg_version')

pg_dba = input('pg_dba')

pg_dba_password = input('pg_dba_password')

pg_db = input('pg_db')

pg_host = input('pg_host')

	sql = postgres_session(pg_dba, pg_dba_password, pg_host, input('pg_port'))

	describe sql.query('SHOW log_destination;', [pg_db]) do
	  its('output') { should match /syslog/i }
	end
  
	describe sql.query('SHOW syslog_facility;', [pg_db]) do
	  its('output') { should match /local[0-7]/i }
	end
  end
