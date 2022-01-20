# encoding: UTF-8

control	'V-233581' do
	title	"PostgreSQL must generate time stamps, for audit records and application data, with a minimum 
	granularity of one second."
	desc	"Without sufficient granularity of time stamps, it is not possible to adequately determine the 
	chronological order of records. 

Time stamps generated by PostgreSQL must include date and time. Granularity of time measurements refers to the 
precision available in time stamp values. Granularity coarser than one second is not sufficient for audit trail 
purposes. Time stamp values are typically presented with three or more decimal places of seconds; however, the 
actual granularity may be coarser than the apparent precision. For example, PostgreSQL will always return at least 
millisecond timestamps but it can be truncated using EXTRACT functions: SELECT EXTRACT(MINUTE FROM TIMESTAMP 
	'2001-02-16 20:38:40');"
	desc	'rationale', ''
	desc	'check', "Note: The following instructions use the PGDATA environment variable. See supplementary 
	content APPENDIX-F for instructions on configuring PGDATA and APPENDIX-I for PGLOG.

First, as the database administrator (shown here as \"postgres\"), verify the current log_line_prefix setting by 
running the following SQL:

$ sudo su - postgres
$ psql -c \"SHOW log_line_prefix\"

If log_line_prefix does not contain %m, this is a finding.

Next check the logs to verify time stamps are being logged:

$ sudo su - postgres
$ cat ${PGDATA?}/${PGLOG?}/<latest_log>
< 2016-02-23 12:53:33.947 EDT postgres postgres 570bd68d.3912 >LOG: connection authorized: user=postgres 
database=postgres
< 2016-02-23 12:53:41.576 EDT postgres postgres 570bd68d.3912 >LOG: AUDIT: SESSION,1,1,DDL,CREATE TABLE,,,CREATE 
TABLE test_srg(id INT);,<none>
< 2016-02-23 12:53:44.372 EDT postgres postgres 570bd68d.3912 >LOG: disconnection: session time: 0:00:10.426 
user=postgres database=postgres host=[local]

If time stamps are not being logged, this is a finding."
	desc	'fix', "Note: The following instructions use the PGDATA and PGVER environment variables. See 
	supplementary content APPENDIX-F for instructions on configuring PGDATA and APPENDIX-H for PGVER.

PostgreSQL will not log anything if logging is not enabled. To ensure that logging is enabled, review supplementary 
content APPENDIX-C for instructions on enabling logging.

If logging is enabled the following configurations must be made to log events with time stamps:

First, as the database administrator (shown here as \"postgres\"), edit postgresql.conf:

$ sudo su - postgres
$ vi ${PGDATA?}/postgresql.conf

Add %m to log_line_prefix to enable time stamps with milliseconds:

log_line_prefix = '< %m >'

Now, as the system administrator, reload the server with the new configuration:

$ sudo systemctl reload postgresql-${PGVER?}"
	impact 0.5
	tag severity: 'medium'
  tag gtitle: 'SRG-APP-000375-DB-000323'
  tag gid: 'V-233581'
  tag rid: 'SV-233581r617333_rule'
  tag stig_id: 'CD12-00-007700'
  tag fix_id: 'F-36740r606967_fix'
  tag cci: ["CCI-001889"]
  tag nist: ["AU-8 b"]

pg_ver = input('pg_version')

pg_dba = input('pg_dba')

pg_dba_password = input('pg_dba_password')

pg_db = input('pg_db')

pg_host = input('pg_host')

	sql = postgres_session(pg_dba, pg_dba_password, pg_host, input('pg_port'))

	describe sql.query('SHOW log_line_prefix;', [pg_db]) do
	  its('output') { should match '%m' }
	end
  end

