{<CODEFILE Path="local_db.code" Hash="1B2M2Y8AsgTpgAmY7PhCfg==" />}
#+ DB schema - Constraints Management (local_db)

--------------------------------------------------------------------------------
--This code is generated with the template dbapp4.0
--Warning: Enter your changes within a <BLOCK> or <POINT> section, otherwise they will be lost.
{<POINT Name="user.comments">} {</POINT>}

--------------------------------------------------------------------------------
--Importing modules
IMPORT FGL libdbappCore
{<POINT Name="import">} {</POINT>}

--------------------------------------------------------------------------------
--Database schema
SCHEMA local_db

--------------------------------------------------------------------------------
--Functions

{<BLOCK Name="fct.payload_queue_checkTableConstraints">}
#+ Check constraints on the "payload_queue" table
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_data - a row data LIKE payload_queue.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_checkTableConstraints(p_forUpdate, p_data)
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_data RECORD LIKE payload_queue.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE l_errNo INTEGER
    DEFINE l_errMsg STRING
    {<POINT Name="fct.payload_queue_checkTableConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_checkTableConstraints.init">} {</POINT>}

    CALL local_db_dbxconstraints_payload_queue_p_q_index_checkColumnConstraints(p_data.p_q_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_payload_queue_requested_by_checkColumnConstraints(p_data.requested_by) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_payload_queue_requested_date_checkColumnConstraints(p_data.requested_date) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_payload_queue_destination_checkColumnConstraints(p_data.destination) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_payload_queue_payload_type_checkColumnConstraints(p_data.payload_type) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_payload_queue_payload_checkColumnConstraints(p_data.payload) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    CALL local_db_dbxconstraints_payload_queue_primary_key_payload_queue_checkUniqueConstraint(p_forUpdate, p_data.p_q_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    {<POINT Name="fct.payload_queue_checkTableConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_checkTableConstraints

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_checkUniqueConstraint">}
#+ Check the primary key uniqueness constraint on the "payload_queue"
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER, STRING, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_primary_key_payload_queue_checkUniqueConstraint(p_forUpdate, p_key)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE l_key
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkUniqueConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    LET l_where = "WHERE payload_queue.p_q_index = ? "
    LET l_sqlQuery = "SELECT COUNT(*), p_q_index FROM payload_queue ", l_where, " GROUP BY p_q_index"
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkUniqueConstraint.init">} {</POINT>}
    TRY
        PREPARE cur_payload_queue_primary_key_payload_queue_checkUniqueConstraint FROM l_sqlQuery
        EXECUTE cur_payload_queue_primary_key_payload_queue_checkUniqueConstraint USING p_key.* INTO l_count, l_key.*
        FREE cur_payload_queue_primary_key_payload_queue_checkUniqueConstraint
        IF (NOT p_forUpdate AND l_count > 0) OR (p_forUpdate AND l_count > 0 AND p_key.* != l_key.*) THEN
            CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- p_q_index: " || ERROR_BAM_00002) RETURNING errNo, errMsg
        END IF
    CATCH
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkUniqueConstraint.user">} {</POINT>}

    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_checkUniqueConstraint

{<BLOCK Name="fct.payload_queue_p_q_index_checkColumnConstraints">}
#+ Check constraints on the "payload_queue.p_q_index" column
#+
#+ @param p_p_q_index - INTEGER - p_q_index
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_p_q_index_checkColumnConstraints(p_p_q_index)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_p_q_index LIKE payload_queue.p_q_index
    {<POINT Name="fct.payload_queue_p_q_index_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_p_q_index_checkColumnConstraints.init">} {</POINT>}
    IF p_p_q_index IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- p_q_index: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.payload_queue_p_q_index_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_p_q_index_checkColumnConstraints

{<BLOCK Name="fct.payload_queue_requested_by_checkColumnConstraints">}
#+ Check constraints on the "payload_queue.requested_by" column
#+
#+ @param p_requested_by - VARCHAR(255) - requested_by
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_requested_by_checkColumnConstraints(p_requested_by)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_requested_by LIKE payload_queue.requested_by
    {<POINT Name="fct.payload_queue_requested_by_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_requested_by_checkColumnConstraints.init">} {</POINT>}
    IF p_requested_by IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- requested_by: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.payload_queue_requested_by_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_requested_by_checkColumnConstraints

{<BLOCK Name="fct.payload_queue_requested_date_checkColumnConstraints">}
#+ Check constraints on the "payload_queue.requested_date" column
#+
#+ @param p_requested_date - DATETIME YEAR TO SECOND - requested_date
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_requested_date_checkColumnConstraints(p_requested_date)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_requested_date LIKE payload_queue.requested_date
    {<POINT Name="fct.payload_queue_requested_date_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_requested_date_checkColumnConstraints.init">} {</POINT>}
    IF p_requested_date IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- requested_date: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.payload_queue_requested_date_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_requested_date_checkColumnConstraints

{<BLOCK Name="fct.payload_queue_destination_checkColumnConstraints">}
#+ Check constraints on the "payload_queue.destination" column
#+
#+ @param p_destination - VARCHAR(255) - destination
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_destination_checkColumnConstraints(p_destination)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_destination LIKE payload_queue.destination
    {<POINT Name="fct.payload_queue_destination_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_destination_checkColumnConstraints.init">} {</POINT>}
    IF p_destination IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- destination: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.payload_queue_destination_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_destination_checkColumnConstraints

{<BLOCK Name="fct.payload_queue_payload_type_checkColumnConstraints">}
#+ Check constraints on the "payload_queue.payload_type" column
#+
#+ @param p_payload_type - VARCHAR(64) - payload_type
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_payload_type_checkColumnConstraints(p_payload_type)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_payload_type LIKE payload_queue.payload_type
    {<POINT Name="fct.payload_queue_payload_type_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_payload_type_checkColumnConstraints.init">} {</POINT>}
    IF p_payload_type IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- payload_type: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.payload_queue_payload_type_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_payload_type_checkColumnConstraints

{<BLOCK Name="fct.payload_queue_payload_checkColumnConstraints">}
#+ Check constraints on the "payload_queue.payload" column
#+
#+ @param p_payload - BYTE - payload
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_payload_checkColumnConstraints(p_payload)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_payload LIKE payload_queue.payload
    {<POINT Name="fct.payload_queue_payload_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.payload_queue_payload_checkColumnConstraints.init">} {</POINT>}
    IF p_payload IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- payload: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.payload_queue_payload_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_payload_checkColumnConstraints

{<BLOCK Name="fct.payload_queue_primary_key_payload_queue_checkFKConstraint">}
#+ Check the Foreign Key existence constraint on the "payload_queue"
#+
#+ @param p_data - Primary Key
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_payload_queue_primary_key_payload_queue_checkFKConstraint(p_data)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_data
        RECORD
            payload_queue_p_q_index LIKE payload_queue.p_q_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkFKConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    IF NOT (p_data.payload_queue_p_q_index IS NULL) THEN
        LET l_where = "WHERE payload_queue.p_q_index = ? "
        LET l_sqlQuery = "SELECT COUNT(*) FROM payload_queue ", l_where
        {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkFKConstraint.init">} {</POINT>}
        TRY
            PREPARE cur_payload_queue_primary_key_payload_queue_checkFKConstraint FROM l_sqlQuery
            EXECUTE cur_payload_queue_primary_key_payload_queue_checkFKConstraint USING p_data.* INTO l_count
            FREE cur_payload_queue_primary_key_payload_queue_checkFKConstraint
            IF (l_count == 0) THEN
                CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- p_q_index: " || ERROR_BAM_00004) RETURNING errNo, errMsg
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
    END IF
    {<POINT Name="fct.payload_queue_primary_key_payload_queue_checkFKConstraint.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.payload_queue_primary_key_payload_queue_checkFKConstraint

{<BLOCK Name="fct.local_stat_checkTableConstraints">}
#+ Check constraints on the "local_stat" table
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_data - a row data LIKE local_stat.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_checkTableConstraints(p_forUpdate, p_data)
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_data RECORD LIKE local_stat.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE l_errNo INTEGER
    DEFINE l_errMsg STRING
    {<POINT Name="fct.local_stat_checkTableConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_stat_checkTableConstraints.init">} {</POINT>}

    CALL local_db_dbxconstraints_local_stat_l_s_index_checkColumnConstraints(p_data.l_s_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_stat_deployment_type_checkColumnConstraints(p_data.deployment_type) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_stat_os_type_checkColumnConstraints(p_data.os_type) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_stat_last_load_checkColumnConstraints(p_data.last_load) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    CALL local_db_dbxconstraints_local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint(p_forUpdate, p_data.l_s_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    {<POINT Name="fct.local_stat_checkTableConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_checkTableConstraints

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint">}
#+ Check the primary key uniqueness constraint on the "local_stat"
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER, STRING, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint(p_forUpdate, p_key)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE l_key
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    LET l_where = "WHERE local_stat.l_s_index = ? "
    LET l_sqlQuery = "SELECT COUNT(*), l_s_index FROM local_stat ", l_where, " GROUP BY l_s_index"
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint.init">} {</POINT>}
    TRY
        PREPARE cur_local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint FROM l_sqlQuery
        EXECUTE cur_local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint USING p_key.* INTO l_count, l_key.*
        FREE cur_local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint
        IF (NOT p_forUpdate AND l_count > 0) OR (p_forUpdate AND l_count > 0 AND p_key.* != l_key.*) THEN
            CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_s_index: " || ERROR_BAM_00002) RETURNING errNo, errMsg
        END IF
    CATCH
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint.user">} {</POINT>}

    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_checkUniqueConstraint

{<BLOCK Name="fct.local_stat_l_s_index_checkColumnConstraints">}
#+ Check constraints on the "local_stat.l_s_index" column
#+
#+ @param p_l_s_index - INTEGER - l_s_index
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_l_s_index_checkColumnConstraints(p_l_s_index)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_l_s_index LIKE local_stat.l_s_index
    {<POINT Name="fct.local_stat_l_s_index_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_stat_l_s_index_checkColumnConstraints.init">} {</POINT>}
    IF p_l_s_index IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_s_index: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_stat_l_s_index_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_l_s_index_checkColumnConstraints

{<BLOCK Name="fct.local_stat_deployment_type_checkColumnConstraints">}
#+ Check constraints on the "local_stat.deployment_type" column
#+
#+ @param p_deployment_type - VARCHAR(255) - deployment_type
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_deployment_type_checkColumnConstraints(p_deployment_type)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_deployment_type LIKE local_stat.deployment_type
    {<POINT Name="fct.local_stat_deployment_type_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_stat_deployment_type_checkColumnConstraints.init">} {</POINT>}
    IF p_deployment_type IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- deployment_type: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_stat_deployment_type_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_deployment_type_checkColumnConstraints

{<BLOCK Name="fct.local_stat_os_type_checkColumnConstraints">}
#+ Check constraints on the "local_stat.os_type" column
#+
#+ @param p_os_type - VARCHAR(255) - os_type
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_os_type_checkColumnConstraints(p_os_type)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_os_type LIKE local_stat.os_type
    {<POINT Name="fct.local_stat_os_type_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_stat_os_type_checkColumnConstraints.init">} {</POINT>}
    IF p_os_type IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- os_type: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_stat_os_type_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_os_type_checkColumnConstraints

{<BLOCK Name="fct.local_stat_last_load_checkColumnConstraints">}
#+ Check constraints on the "local_stat.last_load" column
#+
#+ @param p_last_load - DATETIME YEAR TO SECOND - last_load
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_last_load_checkColumnConstraints(p_last_load)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_last_load LIKE local_stat.last_load
    {<POINT Name="fct.local_stat_last_load_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_stat_last_load_checkColumnConstraints.init">} {</POINT>}
    IF p_last_load IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- last_load: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_stat_last_load_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_last_load_checkColumnConstraints

{<BLOCK Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint">}
#+ Check the Foreign Key existence constraint on the "local_stat"
#+
#+ @param p_data - Primary Key
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint(p_data)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_data
        RECORD
            local_stat_l_s_index LIKE local_stat.l_s_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    IF NOT (p_data.local_stat_l_s_index IS NULL) THEN
        LET l_where = "WHERE local_stat.l_s_index = ? "
        LET l_sqlQuery = "SELECT COUNT(*) FROM local_stat ", l_where
        {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint.init">} {</POINT>}
        TRY
            PREPARE cur_local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint FROM l_sqlQuery
            EXECUTE cur_local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint USING p_data.* INTO l_count
            FREE cur_local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint
            IF (l_count == 0) THEN
                CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_s_index: " || ERROR_BAM_00004) RETURNING errNo, errMsg
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
    END IF
    {<POINT Name="fct.local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_stat_sqlite_autoindex_local_stat_1_checkFKConstraint

{<BLOCK Name="fct.local_remember_checkTableConstraints">}
#+ Check constraints on the "local_remember" table
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_data - a row data LIKE local_remember.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_remember_checkTableConstraints(p_forUpdate, p_data)
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_data RECORD LIKE local_remember.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE l_errNo INTEGER
    DEFINE l_errMsg STRING
    {<POINT Name="fct.local_remember_checkTableConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_remember_checkTableConstraints.init">} {</POINT>}

    CALL local_db_dbxconstraints_local_remember_l_r_index_checkColumnConstraints(p_data.l_r_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_remember_remember_checkColumnConstraints(p_data.remember) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    CALL local_db_dbxconstraints_local_remember_primary_key_local_remember_checkUniqueConstraint(p_forUpdate, p_data.l_r_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    {<POINT Name="fct.local_remember_checkTableConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_remember_checkTableConstraints

{<BLOCK Name="fct.local_remember_primary_key_local_remember_checkUniqueConstraint">}
#+ Check the primary key uniqueness constraint on the "local_remember"
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER, STRING, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_remember_primary_key_local_remember_checkUniqueConstraint(p_forUpdate, p_key)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE l_key
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkUniqueConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    LET l_where = "WHERE local_remember.l_r_index = ? "
    LET l_sqlQuery = "SELECT COUNT(*), l_r_index FROM local_remember ", l_where, " GROUP BY l_r_index"
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkUniqueConstraint.init">} {</POINT>}
    TRY
        PREPARE cur_local_remember_primary_key_local_remember_checkUniqueConstraint FROM l_sqlQuery
        EXECUTE cur_local_remember_primary_key_local_remember_checkUniqueConstraint USING p_key.* INTO l_count, l_key.*
        FREE cur_local_remember_primary_key_local_remember_checkUniqueConstraint
        IF (NOT p_forUpdate AND l_count > 0) OR (p_forUpdate AND l_count > 0 AND p_key.* != l_key.*) THEN
            CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_r_index: " || ERROR_BAM_00002) RETURNING errNo, errMsg
        END IF
    CATCH
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkUniqueConstraint.user">} {</POINT>}

    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_checkUniqueConstraint

{<BLOCK Name="fct.local_remember_l_r_index_checkColumnConstraints">}
#+ Check constraints on the "local_remember.l_r_index" column
#+
#+ @param p_l_r_index - INTEGER - l_r_index
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_remember_l_r_index_checkColumnConstraints(p_l_r_index)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_l_r_index LIKE local_remember.l_r_index
    {<POINT Name="fct.local_remember_l_r_index_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_remember_l_r_index_checkColumnConstraints.init">} {</POINT>}
    IF p_l_r_index IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_r_index: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_remember_l_r_index_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_remember_l_r_index_checkColumnConstraints

{<BLOCK Name="fct.local_remember_remember_checkColumnConstraints">}
#+ Check constraints on the "local_remember.remember" column
#+
#+ @param p_remember - SMALLINT - remember
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_remember_remember_checkColumnConstraints(p_remember)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_remember LIKE local_remember.remember
    {<POINT Name="fct.local_remember_remember_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_remember_remember_checkColumnConstraints.init">} {</POINT>}
    IF p_remember IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- remember: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_remember_remember_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_remember_remember_checkColumnConstraints

{<BLOCK Name="fct.local_remember_primary_key_local_remember_checkFKConstraint">}
#+ Check the Foreign Key existence constraint on the "local_remember"
#+
#+ @param p_data - Primary Key
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_remember_primary_key_local_remember_checkFKConstraint(p_data)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_data
        RECORD
            local_remember_l_r_index LIKE local_remember.l_r_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkFKConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    IF NOT (p_data.local_remember_l_r_index IS NULL) THEN
        LET l_where = "WHERE local_remember.l_r_index = ? "
        LET l_sqlQuery = "SELECT COUNT(*) FROM local_remember ", l_where
        {<POINT Name="fct.local_remember_primary_key_local_remember_checkFKConstraint.init">} {</POINT>}
        TRY
            PREPARE cur_local_remember_primary_key_local_remember_checkFKConstraint FROM l_sqlQuery
            EXECUTE cur_local_remember_primary_key_local_remember_checkFKConstraint USING p_data.* INTO l_count
            FREE cur_local_remember_primary_key_local_remember_checkFKConstraint
            IF (l_count == 0) THEN
                CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_r_index: " || ERROR_BAM_00004) RETURNING errNo, errMsg
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
    END IF
    {<POINT Name="fct.local_remember_primary_key_local_remember_checkFKConstraint.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_remember_primary_key_local_remember_checkFKConstraint

{<BLOCK Name="fct.local_accounts_checkTableConstraints">}
#+ Check constraints on the "local_accounts" table
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_data - a row data LIKE local_accounts.*
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_checkTableConstraints(p_forUpdate, p_data)
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_data RECORD LIKE local_accounts.*
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE l_errNo INTEGER
    DEFINE l_errMsg STRING
    {<POINT Name="fct.local_accounts_checkTableConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_accounts_checkTableConstraints.init">} {</POINT>}

    CALL local_db_dbxconstraints_local_accounts_l_u_index_checkColumnConstraints(p_data.l_u_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_accounts_username_checkColumnConstraints(p_data.username) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_accounts_password_checkColumnConstraints(p_data.password) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    CALL local_db_dbxconstraints_local_accounts_primary_key_local_accounts_checkUniqueConstraint(p_forUpdate, p_data.l_u_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg
    CALL local_db_dbxconstraints_local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint(p_forUpdate, p_data.username, p_data.l_u_index) RETURNING l_errNo, l_errMsg
    CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, l_errNo, l_errMsg) RETURNING errNo, errMsg

    {<POINT Name="fct.local_accounts_checkTableConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_checkTableConstraints

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_checkUniqueConstraint">}
#+ Check the primary key uniqueness constraint on the "local_accounts"
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_key - Primary Key
#+
#+ @returnType INTEGER, STRING, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_primary_key_local_accounts_checkUniqueConstraint(p_forUpdate, p_key)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkUniqueConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    LET l_where = "WHERE local_accounts.l_u_index = ? "
    LET l_sqlQuery = "SELECT COUNT(*), l_u_index FROM local_accounts ", l_where, " GROUP BY l_u_index"
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkUniqueConstraint.init">} {</POINT>}
    TRY
        PREPARE cur_local_accounts_primary_key_local_accounts_checkUniqueConstraint FROM l_sqlQuery
        EXECUTE cur_local_accounts_primary_key_local_accounts_checkUniqueConstraint USING p_key.* INTO l_count, l_key.*
        FREE cur_local_accounts_primary_key_local_accounts_checkUniqueConstraint
        IF (NOT p_forUpdate AND l_count > 0) OR (p_forUpdate AND l_count > 0 AND p_key.* != l_key.*) THEN
            CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_u_index: " || ERROR_BAM_00002) RETURNING errNo, errMsg
        END IF
    CATCH
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkUniqueConstraint.user">} {</POINT>}

    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_checkUniqueConstraint

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint">}
#+ Check the secondary key uniqueness constraint on the "local_accounts"
#+
#+ @param p_forUpdate TRUE: for 'update' SQL operation, FALSE for 'insert' SQL operation
#+ @param p_data - Secondary Key
#+
#+ @returnType INTEGER, STRING, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint(p_forUpdate, p_data, p_key)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_forUpdate BOOLEAN
    DEFINE p_data
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE l_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE p_key
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    LET l_where = "WHERE local_accounts.username = ? "
    LET l_sqlQuery = "SELECT COUNT(*), l_u_index FROM local_accounts ", l_where, " GROUP BY l_u_index"
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint.init">} {</POINT>}
    TRY
        PREPARE cur_local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint FROM l_sqlQuery
        EXECUTE cur_local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint USING p_data.* INTO l_count, l_key.*
        FREE cur_local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint
        IF (NOT p_forUpdate AND l_count > 0) OR (p_forUpdate AND l_count > 0 AND p_key.* != l_key.*) THEN
            CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- username: " || ERROR_BAM_00003) RETURNING errNo, errMsg
        END IF
    CATCH
        LET errNo = ERROR_FAILURE
    END TRY
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint.user">} {</POINT>}

    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_checkUniqueConstraint

{<BLOCK Name="fct.local_accounts_l_u_index_checkColumnConstraints">}
#+ Check constraints on the "local_accounts.l_u_index" column
#+
#+ @param p_l_u_index - INTEGER - l_u_index
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_l_u_index_checkColumnConstraints(p_l_u_index)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_l_u_index LIKE local_accounts.l_u_index
    {<POINT Name="fct.local_accounts_l_u_index_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_accounts_l_u_index_checkColumnConstraints.init">} {</POINT>}
    IF p_l_u_index IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_u_index: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_accounts_l_u_index_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_l_u_index_checkColumnConstraints

{<BLOCK Name="fct.local_accounts_username_checkColumnConstraints">}
#+ Check constraints on the "local_accounts.username" column
#+
#+ @param p_username - VARCHAR(255) - username
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_username_checkColumnConstraints(p_username)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_username LIKE local_accounts.username
    {<POINT Name="fct.local_accounts_username_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_accounts_username_checkColumnConstraints.init">} {</POINT>}
    IF p_username IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- username: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_accounts_username_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_username_checkColumnConstraints

{<BLOCK Name="fct.local_accounts_password_checkColumnConstraints">}
#+ Check constraints on the "local_accounts.password" column
#+
#+ @param p_password - VARCHAR(255) - password
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_password_checkColumnConstraints(p_password)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_password LIKE local_accounts.password
    {<POINT Name="fct.local_accounts_password_checkColumnConstraints.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    {<POINT Name="fct.local_accounts_password_checkColumnConstraints.init">} {</POINT>}
    IF p_password IS NULL THEN
        CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- password: " || ERROR_BAM_00001) RETURNING errNo, errMsg
    END IF
    {<POINT Name="fct.local_accounts_password_checkColumnConstraints.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_password_checkColumnConstraints

{<BLOCK Name="fct.local_accounts_primary_key_local_accounts_checkFKConstraint">}
#+ Check the Foreign Key existence constraint on the "local_accounts"
#+
#+ @param p_data - Primary Key
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_primary_key_local_accounts_checkFKConstraint(p_data)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_data
        RECORD
            local_accounts_l_u_index LIKE local_accounts.l_u_index
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkFKConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    IF NOT (p_data.local_accounts_l_u_index IS NULL) THEN
        LET l_where = "WHERE local_accounts.l_u_index = ? "
        LET l_sqlQuery = "SELECT COUNT(*) FROM local_accounts ", l_where
        {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkFKConstraint.init">} {</POINT>}
        TRY
            PREPARE cur_local_accounts_primary_key_local_accounts_checkFKConstraint FROM l_sqlQuery
            EXECUTE cur_local_accounts_primary_key_local_accounts_checkFKConstraint USING p_data.* INTO l_count
            FREE cur_local_accounts_primary_key_local_accounts_checkFKConstraint
            IF (l_count == 0) THEN
                CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- l_u_index: " || ERROR_BAM_00004) RETURNING errNo, errMsg
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
    END IF
    {<POINT Name="fct.local_accounts_primary_key_local_accounts_checkFKConstraint.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_primary_key_local_accounts_checkFKConstraint

{<BLOCK Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint">}
#+ Check the Foreign Key existence constraint on the "local_accounts"
#+
#+ @param p_data - Secondary Key
#+
#+ @returnType INTEGER, STRING
#+ @return     ERROR_SUCCESS|ERROR_FAILURE, error message
PUBLIC FUNCTION local_db_dbxconstraints_local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint(p_data)
    DEFINE errNo INTEGER
    DEFINE errMsg STRING
    DEFINE p_data
        RECORD
            local_accounts_username LIKE local_accounts.username
        END RECORD
    DEFINE l_where STRING
    DEFINE l_sqlQuery STRING
    DEFINE l_count INTEGER
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint.define">} {</POINT>}

    LET errNo = ERROR_SUCCESS
    INITIALIZE errMsg TO NULL
    IF NOT (p_data.local_accounts_username IS NULL) THEN
        LET l_where = "WHERE local_accounts.username = ? "
        LET l_sqlQuery = "SELECT COUNT(*) FROM local_accounts ", l_where
        {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint.init">} {</POINT>}
        TRY
            PREPARE cur_local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint FROM l_sqlQuery
            EXECUTE cur_local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint USING p_data.* INTO l_count
            FREE cur_local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint
            IF (l_count == 0) THEN
                CALL libdbapp_utilBuildErrorNoAndErrorMsg(errNo, errMsg, ERROR_FAILURE, "\n- username: " || ERROR_BAM_00004) RETURNING errNo, errMsg
            END IF
        CATCH
            LET errNo = ERROR_FAILURE
        END TRY
    END IF
    {<POINT Name="fct.local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint.user">} {</POINT>}
    RETURN errNo, errMsg
END FUNCTION
{</BLOCK>} --fct.local_accounts_sqlite_autoindex_local_accounts_1_checkFKConstraint

--------------------------------------------------------------------------------
--Add user functions
{<POINT Name="user.functions">} {</POINT>}
