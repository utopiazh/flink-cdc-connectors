#!/usr/bin/env bash
################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################
STAGE_MYSQL="mysql"
STAGE_POSTGRES="postgres"
STAGE_ORACLE="oracle"
STAGE_MONGODB="mongodb"
STAGE_MISC="misc"

MODULES_MYSQL="\
flink-connector-mysql-cdc,\
flink-sql-connector-mysql-cdc"

MODULES_POSTGRES="\
flink-connector-postgres-cdc,\
flink-sql-connector-postgres-cdc"

MODULES_ORACLE="\
flink-connector-oracle-cdc,\
flink-sql-connector-oracle-cdc"

MODULES_MONGODB="\
flink-connector-mongodb-cdc,\
flink-sql-connector-mongodb-cdc"

function get_compile_modules_for_stage() {
    local stage=$1

    case ${stage} in
        (${STAGE_MYSQL})
            echo "-pl $MODULES_MYSQL -am"
        ;;
        (${STAGE_POSTGRES})
            echo "-pl $MODULES_POSTGRES -am"
        ;;
        (${STAGE_ORACLE})
            echo "-pl $MODULES_ORACLE -am"
        ;;
        (${STAGE_MONGODB})
            echo "-pl $MODULES_MONGODB -am"
        ;;
        (${STAGE_MISC})
            # compile everything; using the -am switch does not work with negated module lists!
            # the negation takes precedence, thus not all required modules would be built
            echo ""
        ;;
    esac
}

function get_test_modules_for_stage() {
    local stage=$1

    local modules_mysql=$MODULES_MYSQL
    local modules_postgres=$MODULES_POSTGRES
    local modules_oracle=$MODULES_ORACLE
    local modules_mongodb=$MODULES_MONGODB
    local negated_mysql=\!${MODULES_MYSQL//,/,\!}
    local negated_postgres=\!${MODULES_POSTGRES//,/,\!}
    local negated_oracle=\!${MODULES_ORACLE//,/,\!}
    local negated_mongodb=\!${MODULES_MONGODB//,/,\!}
    local modules_misc="$negated_mysql,$negated_postgres,$negated_oracle,$negated_mongodb"

    case ${stage} in
        (${STAGE_MYSQL})
            echo "-pl $modules_mysql"
        ;;
        (${STAGE_POSTGRES})
            echo "-pl $modules_postgres"
        ;;
        (${STAGE_ORACLE})
            echo "-pl $modules_oracle"
        ;;
        (${STAGE_MONGODB})
            echo "-pl $modules_mongodb"
        ;;
        (${STAGE_MISC})
            echo "-pl $modules_misc"
        ;;
    esac
}
