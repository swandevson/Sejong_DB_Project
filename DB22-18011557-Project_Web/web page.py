import pymssql
from flask import Flask, render_template, request
from beer_data import get_ctg_info, get_dist_name, get_beer_list, add_beer_info, del_beer_info
from employee_data import get_rank_info, get_employee_list, add_employee_info, del_employee_info
from csm_data import get_csm_list
from order_data import get_order_list


app = Flask("Beer Shop DBMS")

# connect mssql server
conn = pymssql.connect(host='localhost',
                       database='beerShop_DB')
cursor = conn.cursor()

# temporary database
beer_db = []
employee_db = []

@app.route('/', methods=['GET'])
def home():
    return render_template('index.html')

# transport data with POST
@app.route('/search_beer', methods=['GET', 'POST'])
def serach_beer():
    args_dict = request.form.to_dict()
    print(args_dict)
    
    return render_template('search_beer.html',
                           ctg_list = get_ctg_info(cursor),
                           dist_list = get_dist_name(cursor),
                           beer_list = get_beer_list(cursor, args_dict))

@app.route('/search_employee', methods=['GET', 'POST'])
def search_employee():
    args_dict = request.form.to_dict()

    print(args_dict)

    return render_template('search_employee.html',
                           rank_list = get_rank_info(cursor),
                           employee_list = get_employee_list(cursor, args_dict))

@app.route('/search_customer', methods=['GET', 'POST'])
def search_customer():
    args_dict = request.form.to_dict()

    print(args_dict)

    return render_template('search_customer.html',
                           csm_list = get_csm_list(cursor, args_dict))

@app.route('/search_order', methods=['GET', 'POST'])
def search_order():
    args_dict = request.form.to_dict()

    print(args_dict)

    return render_template('search_order.html',
                           order_list = get_order_list(cursor, args_dict))





# add/delete beer
@app.route('/add_beer', methods=['GET', 'POST'])
def add_beer():
    args_dict = request.form.to_dict()
    print(args_dict)

    add_beer_info(cursor, args_dict)
        
    

    return render_template('add_beer.html',
                           ctg_list = get_ctg_info(cursor),
                           dist_list = get_dist_name(cursor))

@app.route('/del_beer', methods=['GET', 'POST'])
def del_beer():
    args_dict = request.form.to_dict()
    global beer_db
    print(beer_db)
     
    print(len(args_dict))
    if len(args_dict) == 1:
        del_beer_info(cursor, args_dict['beer-ID'])
        for i in range(len(beer_db)):
            if beer_db[i][0] == args_dict['beer-ID']:
                del beer_db[i]
                break
        
    else:
        beer_db = get_beer_list(cursor, args_dict)
    
    #print(beer_db)

    return render_template('del_beer.html',
                           ctg_list = get_ctg_info(cursor),
                           dist_list = get_dist_name(cursor),
                           beer_list = beer_db)


# add/delete employee
@app.route('/add_employee', methods=['GET', 'POST'])
def add_employee():
    args_dict = request.form.to_dict()
    print(args_dict)

    add_employee_info(cursor, args_dict)

    return render_template('add_employee.html',
                           rank_list = get_rank_info(cursor))

@app.route('/del_employee', methods=['GET', 'POST'])
def del_employee():
    args_dict = request.form.to_dict()
    global employee_db

    print(employee_db)
     
    print(len(args_dict))
    if len(args_dict) == 1:
        del_employee_info(cursor, args_dict['employee-ID'])
        for i in range(len(employee_db)):
            if employee_db[i][0] == args_dict['employee-ID']:
                del employee_db[i]
                break
        
    else:
        employee_db = get_employee_list(cursor, args_dict)
    

    return render_template('del_employee.html',
                           rank_list = get_rank_info(cursor),
                           employee_list = employee_db)


app.run()

conn.close()
