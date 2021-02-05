# encoding: UTF-8

pg_owner = input('pg_owner')

pg_group = input('pg_group')

pg_data_dir = input('pg_data_dir')

control	'V-233617' do
	title	"Access to database files must be limited to relevant processes and to authorized, administrative users."
	desc	"Applications, including PostgreSQL, must prevent unauthorized and unintended information transfer 
	via shared system resources. Permitting only DBMS processes and authorized, administrative users to have access 
	to the files where the database resides helps ensure that those files are not shared inappropriately and are not 
	open to backdoor access and manipulation."
	desc	'rationale', ''
	desc	'check', "Note: The following instructions use the PGDATA environment variable. See supplementary content 
	APPENDIX-F for instructions on configuring PGDATA.

Review the permissions granted to users by the operating system/file system on the database files, database log 
files and database backup files. 

To verify that all files are owned by the database administrator and have the correct permissions, run the following 
as the database administrator (shown here as \"postgres\"):

$ sudo su - postgres
$ ls -lR ${PGDATA?}

If any files are not owned by the database administrator or allow anyone but the database administrator to 
read/write/execute, this is a finding.

If any user/role that is not an authorized system administrator with a need-to-know or database administrator with a 
need-to-know, or a system account for running PostgreSQL processes, is permitted to read/view any of these files, 
this is a finding."
	desc	'fix', "Note: The following instructions use the PGDATA environment variable. See supplementary content 
	APPENDIX-F for instructions on configuring PGDATA.

Configure the permissions granted by the operating system/file system on the database files, database log files, and 
database backup files so that only relevant system accounts and authorized system administrators and database 
administrators with a need to know are permitted to read/view these files.

Any files (for example: extra configuration files) created in ${PGDATA?} must be owned by the database administrator, 
with only owner permissions to read, write, and execute."
	impact 0.5
	tag severity: 'medium'
	tag gtitle: nil
	tag gid: nil
	tag rid: nil
	tag stig_id: nil
	tag fix_id: nil
	tag cci: nil
	tag nist: nil

	describe command("find pg_data_dir ! -user pg_owner ! -group pg_group -type f -readable -writable | wc -l") do
		its('stdout.strip') { should eq '0' }
	  end
	end

