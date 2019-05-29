CREATE ROLE cartotester LOGIN;
CREATE TABLE pub(a int);
CREATE TABLE prv(a int);
GRANT SELECT ON TABLE pub TO cartotester;
REVOKE SELECT ON TABLE prv FROM cartotester;
SELECT CDB_UserTables() ORDER BY 1;
SELECT 'all',CDB_UserTables('all') ORDER BY 2;
SELECT 'public',CDB_UserTables('public') ORDER BY 2;
SELECT 'private',CDB_UserTables('private') ORDER BY 2;
SELECT '--unsupported--',CDB_UserTables('--unsupported--') ORDER BY 2;
-- now tests with public user
\c contrib_regression cartotester
SELECT 'all_cartotester',CDB_UserTables('all') ORDER BY 2;
SELECT 'public_cartotester',CDB_UserTables('public') ORDER BY 2;
SELECT 'private_cartotester',CDB_UserTables('private') ORDER BY 2;
\c contrib_regression postgres
DROP TABLE pub;
DROP TABLE prv;
DROP ROLE cartotester;
