import pymssql



def get_ctg_info(cursor):
    cursor.execute('select * from category')

    ctg_list = []
    
    ctg = cursor.fetchone()
    while ctg:
        ctg_list.append(ctg)
        ctg = cursor.fetchone()

    return ctg_list


def get_dist_name(cursor):
    cursor.execute('select * from get_dist_name()')

    dist_name_list = []
    dist_name = cursor.fetchone()
    while dist_name:
        dist_name_list.append(dist_name[0])
        dist_name = cursor.fetchone()

    return dist_name_list


def get_beer_list(cursor, args_dict):
    # Join other tables to make beer info table
    query_str = "select * from beer_info"

    # if URL query string exist
    if args_dict:
        print(args_dict)
        query_str += f" where ({args_dict['ABV-min']} <= ABV and ABV <= {args_dict['ABV-max']})"
    
        if args_dict['beer-name'] !='':
            query_str += f" AND beer_name like '%{args_dict['beer-name']}%'"
        if args_dict['category'] != 'all':
            query_str += f" AND ctg_ID = '{args_dict['category']}'"
        if args_dict['distributor'] != 'all':
            query_str += f" AND dist_name = '{args_dict['distributor']}'"

        if args_dict['order-by'] == 'name-asce':
            query_str += " order by beer_name"
        elif args_dict['order-by'] == 'name-dsce':
            query_str += " order by beer_name DESC"
        elif args_dict['order-by'] == 'ABV-asce':
            query_str += " order by ABV"
        elif args_dict['order-by'] == 'ABV-dsce':
            query_str += " order by ABV DESC"

    #print(query_str)

    # execute query
    cursor.execute(query_str)

    # list to save every beer info
    beer_list = []
    
    row = cursor.fetchone()
    while row:
        
        # add comma to price
        row = list(row)

        row[6] = format(row[6], ',d')

        # add beer information
        beer_list.append(row)

        # fetch next beer's info
        row = cursor.fetchone()

    return beer_list







def add_beer_info(cursor, args_dict):
    if not args_dict:
        return
    
    query_str = 'exec add_beer_info'
    for key in args_dict.keys():
        if key == 'beer-ABV':
            args_dict[key] = float(args_dict[key])
        elif key == 'beer-price' or key == 'beer-stock':
            args_dict[key] = int(args_dict[key])
        else:
            args_dict[key] = f"'{args_dict[key]}'"

        if key != 'beer-ID':
            query_str += f", {args_dict[key]}"
        else:
            query_str += f" {args_dict[key]}"

    query_str += ';'
            
    print(query_str)
   
    try:
        cursor.execute(query_str)
    except:
        print("error occured!")

def del_beer_info(cursor, ID):
    cursor.execute(f"delete from beer where {ID} = beer_ID")

