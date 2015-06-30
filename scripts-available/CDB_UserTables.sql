-- Function returning list of cartodb user tables
--
-- The optional argument restricts the result to tables
-- of the specified access type.
--
-- Currently accepted permissions are: 'public', 'private' or 'all'
--
DROP FUNCTION IF EXISTS cdb_usertables(text);
CREATE OR REPLACE FUNCTION CDB_UserTables(perm text DEFAULT 'all')
RETURNS SETOF name
AS $$

SELECT c.relname 
FROM pg_class c 
JOIN pg_roles r ON r.oid = c.relowner
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE r.rolname = current_user 
AND c.relkind = 'r' 
AND c.relname NOT IN ('cdb_tablemetadata', 'spatial_ref_sys')
AND n.nspname NOT IN ('pg_catalog', 'information_schema')
AND CASE WHEN perm = 'public' THEN has_table_privilege('public', c.oid, 'SELECT')
         WHEN perm = 'private' THEN has_table_privilege(c.oid, 'SELECT') AND NOT 
                                    has_table_privilege('public', c.oid, 'SELECT')
         WHEN perm = 'all' THEN has_table_privilege(c.oid, 'SELECT') 
         ELSE false END;

$$ LANGUAGE 'sql';

-- This is to migrate from pre-0.2.0 version
-- See http://github.com/CartoDB/cartodb-postgresql/issues/36
GRANT EXECUTE ON FUNCTION CDB_UserTables(text) TO public;
