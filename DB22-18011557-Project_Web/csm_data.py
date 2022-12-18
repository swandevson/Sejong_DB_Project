import pymssql


def get_csm_list(cursor, args_dict):
    query_str = "select * from consumer_info"

    # if URL query string exist
    if args_dict:
        print(args_dict)

        if args_dict['csm-name'] != '' and args_dict['csm-ID'] != '':
            query_str += f" where csm_name like '%{args_dict['csm-name']}%' AND csm_ID like '%{args_dict['csm-ID']}%'"

        else:
            if args_dict['csm-name'] != '':
                query_str += f" where csm_name like '%{args_dict['csm-name']}%'"
            if args_dict['csm-ID'] !='':
                query_str += f" where csm_ID like '%{args_dict['csm-ID']}%'"
        

        if args_dict['order-by'] == 'name-asce':
            query_str += " order by csm_name"
        elif args_dict['order-by'] == 'name-dsce':
            query_str += " order by csm_name DESC"
        elif args_dict['order-by'] == 'ID-asce':
            query_str += " order by csm_ID"
        elif args_dict['order-by'] == 'ID-dsce':
            query_str += " order by csm_ID DESC"

    print(query_str)

    # execute query
    cursor.execute(query_str)

    # list to save every consumer's info
    csm_list = []
    
    row = cursor.fetchone()
    while row:
        # add consumer information
        csm_list.append(row)

        # fetch next beer's info
        row = cursor.fetchone()

    print(csm_list)

    return csm_list

