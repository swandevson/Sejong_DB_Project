import pymssql


def get_rank_info(cursor):
    cursor.execute('select * from rank')

    rank_list = []

    rank = cursor.fetchone()
    while rank:
        rank_list.append(rank)
        rank = cursor.fetchone()

    return rank_list



def get_employee_list(cursor, args_dict):
    # Join other tables to make employee info table
    query_str = "select * from employee_info"

    # if URL query string exist
    if args_dict:
        print(args_dict)
        query_str += f" where ({args_dict['wage-min']} <= wage and wage <= {args_dict['wage-max']})"
        query_str += f" AND ({args_dict['career-min']} <= career and career <= {args_dict['career-max']})"
    
        if args_dict['employee-name'] !='':
            query_str += f" AND employee_name like '%{args_dict['employee-name']}%'"
        if args_dict['rank-name'] != 'all':
            query_str += f" AND rank_ID = '{args_dict['rank-name']}'"

        if args_dict['order-by'] == 'name-asce':
            query_str += " order by employee_name"
        elif args_dict['order-by'] == 'name-dsce':
            query_str += " order by employee_name DESC"
        elif args_dict['order-by'] == 'rank-asce':
            query_str += " order by rank_ID, career"
        elif args_dict['order-by'] == 'rank-dsce':
            query_str += " order by rank_ID DESC, career DESC"

    print(query_str)

    # execute query
    cursor.execute(query_str)

    # list to save every beer info
    employee_list = []
    
    row = cursor.fetchone()
    while row:
        # add comma to price
        row = list(row)
        print(row)
        row[6] = format(row[6], ',d')

        # add beer information
        employee_list.append(row)

        # fetch next beer's info
        row = cursor.fetchone()

    return employee_list


def add_employee_info(cursor, args_dict):
    if not args_dict:
        return

    query_str = 'exec add_employee_info'
    for key in args_dict.keys():
        if key == 'employee-career':
            args_dict[key] = int(args_dict[key])
        else:
            args_dict[key] = f"'{args_dict[key]}'"
        
        if key != 'employee-ID':
            query_str += f", {args_dict[key]}"
        else:
            query_str += f" {args_dict[key]}" 

    query_str += ';'
            
    print(query_str)
   

    cursor.execute(query_str)




def del_employee_info(cursor, ID):
    cursor.execute(f"delete from employee where {ID} = employee_ID")
