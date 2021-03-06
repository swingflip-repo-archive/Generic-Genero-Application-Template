# ------------------------------------------------------------------------------
# Database creation script for SQLite
#
# Note: This script is a helper script to create an empty database schema
#       Adapt it to fit your needs
# ------------------------------------------------------------------------------
IMPORT OS

MAIN

    DEFINE f_dbpath STRING
    
    LET f_dbpath = os.path.join(os.path.join(os.path.join(os.path.pwd(), ".."), "database"), "local_db.db")
    
    DATABASE f_dbpath

    CALL db_drop_tables() #THIS WIPES ALL EXISTING DATA! COMMENT OUT IF YOU WANT THE DATA
    CALL db_create_tables()
    CALL db_create_defaults()
END MAIN




