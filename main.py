from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import hashlib, uuid
import pandas as pd
from sqlalchemy import create_engine,exc
from pretty_html_table import build_table
import subprocess
import datetime
import random


app = Flask(__name__)

app.secret_key = 'key'


app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'guest'
app.config['MYSQL_PASSWORD'] = 'guestpassword'
app.config['MYSQL_DB'] = 'liquors_warehouse'


mysql = MySQL(app)


def connect(logg,passw):
    global conn_str , db, connection
    conn_str = 'mysql+pymysql://{0}:{1}@{2}:{3}/{4}?charset=utf8mb4'.format(logg , passw ,"localhost", 3306, "liquors_warehouse")
    db = create_engine(conn_str, encoding='utf8')
    connection = db.connect()



# http://localhost:5000/pythonlogin/ - the following will be our login page, which will use both GET and POST requests
@app.route('/pythonlogin/', methods=['GET', 'POST'])
def login():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username" and "password" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']

        # Check if account exists using MySQL
        
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        select_stmt = ("select if_user_data_valid_return_seed(%s)%s")
        cursor.execute(select_stmt,(username,';'))
        seed1=list(cursor.fetchone().values())[0]
        if str(seed1)=='None':
            # Account doesnt exist or username/password incorrect
            msg = 'Incorrect username/password!'
            return render_template('index.html', msg=msg)
        else:

            seed=str(int(int(seed1)/19-3))
            print(seed)

                
            select_stmt = ('select if_user_data_valid_return_role(%s,%s);')
            m=str.encode(str(password)+ str(seed))
            password_hash= hashlib.sha512(m).hexdigest()
            data = (username,password_hash)
            cursor.execute(select_stmt, data)

            # Fetch one record and return result
            account_type = str(list(cursor.fetchone().values())[0])
            print(account_type)
            cursor.execute('select if_user_data_valid_return_id(%s,%s);', data)
            account_id = str(list(cursor.fetchone().values())[0])
            cursor.close()

            # If account exists in accounts table in out database

            if account_type !='None':
                session['msq_err']='Done'                    
                session['table']=''
                if account_type =='admin':
                    # Connect to the database
                    connect("admin" , "adminpassword")
                    # Create session data, we can access this data in other routes
                    session['loggedin'] = True 
                    session['id'] = account_id 
                    session['username'] = username    
                    session['role']= account_type
                    #Redirect to home page
                    return redirect(url_for('home'))   
                elif account_type =='manager':
                    # Connect to the database
                    connect("manager" , "managerpassword")
                    # Create session data, we can access this data in other routes
                    session['loggedin'] = True 
                    session['id'] = account_id 
                    session['username'] = username    
                    session['role']= account_type
                    #Redirect to home page
                    return redirect(url_for('home'))    
                elif account_type =='worker':
                    # Connect to the database
                    connect("worker" , "workerpassword")
                     # Create session data, we can access this data in other routes
                    session['loggedin'] = True 
                    session['id'] = account_id 
                    session['username'] = username    
                    session['role']= account_type
                    #Redirect to home page
                    return redirect(url_for('home'))              
                elif account_type =='client':
                    # Connect to the database
                    connect("client" ,  "cilentpassword" )
                     # Create session data, we can access this data in other routes
                    session['loggedin'] = True 
                    session['id'] = account_id 
                    session['username'] = username    
                    session['role']= account_type
                    #Redirect to home page
                    return redirect(url_for('home'))     
                elif account_type =='supplier':
                    # Connect to the database
                    connect("supplier" , "supplierpassword")
                     # Create session data, we can access this data in other routes
                    session['loggedin'] = True 
                    session['id'] = account_id 
                    session['username'] = username    
                    session['role']= account_type
                    #Redirect to home page
                    return redirect(url_for('home'))   
                else:
                    msg = 'Incorrect username/password!'
                # Show the login form with message (if any)
                return render_template('index.html', msg=msg)
            else:
                # Account doesnt exist or username/password incorrect
                msg = 'Incorrect username/password!'

    # Show the login form with message (if any)
    return render_template('index.html', msg=msg)



@app.route('/pythonlogin/quantity_on_date', methods=['GET', 'POST'])
def quantity_on_date():
    try:
        Product_ID = request.form['Product_ID']
        Feature_Date = request.form['Feature_Date']
        year, month, day  = Feature_Date.split('-')
        isValidDate = True
        try:
            datetime.datetime(int(year), int(month), int(day))
        except ValueError:
            isValidDate = False
        if Product_ID.isnumeric() and isValidDate :
            try:
                df = pd.read_sql("SELECT quantity_on_date({0},'{1}');".format(Product_ID,Feature_Date), db) #read the entire table
                data=(df.to_dict('records'))
                return render_template('table_view.html',  contacts=data)
            except exc.SQLAlchemyError as e:
                 session['msq_err']=str(e)
            return render_template("home_err.html")
        session['msq_err']="N0Nnumeric data typed or date wrong or not in YYYY-MM-DD format"
        return render_template("home_err.html")
    except:
        session['msq_err']="N0Nnumeric data typed or date wrong or not in YYYY-MM-DD format"
        return render_template("home_err.html")



@app.route('/pythonlogin/sale', methods=['GET', 'POST'])
def sale():
    try:
        df = pd.read_sql('CALL liquors_warehouse.show_sales_for_client({0});'.format(session['id']), db) #read the entire table
        data=(df.to_dict('records'))
        return render_template('table_view.html',  contacts=data)
    except:
        return render_template("home_err.html")
   
@app.route('/pythonlogin/sale_product', methods=['GET', 'POST'])
def sale_product():
    try:
        sale_product1 = request.form['sale_product1']
        if sale_product1.isnumeric()  :
            df = pd.read_sql('CALL liquors_warehouse.show_sales_for_client_product({0},{1});'.format(sale_product1,session['id']), db) #read the entire table
            data=(df.to_dict('records'))
            return render_template('table_view.html',  contacts=data)
        return redirect(url_for('home'))
    except:
        return render_template("home_err.html")
    
@app.route('/pythonlogin/supplier', methods=['GET', 'POST'])
def supplier():
    try:
        df = pd.read_sql('CALL liquors_warehouse.show_suppliers({0});'.format(session['id']), db) #read the entire table
        data=(df.to_dict('records'))
        return render_template('table_view.html',  contacts=data)
    except:
        return render_template("home_err.html")

@app.route('/pythonlogin/supplier_product', methods=['GET', 'POST'])
def supplier_product():
    try:
        supplier_product1 = request.form['supplier_product1']
        if supplier_product1.isnumeric()  :
            df = pd.read_sql('CALL liquors_warehouse.show_suppliers_product({0},{1});'.format(supplier_product1,session['id']), db) #read the entire table
            data=(df.to_dict('records'))
            return render_template('table_view.html',  contacts=data)
        return redirect(url_for('home'))   
    except:
        return render_template("home_err.html")



@app.route('/pythonlogin/home/update1', methods=['GET', 'POST'])
def update1():
    try:
        if request.method == 'POST': 
            if request.form.get('UPDATE_SALE') == 'UPDATE_SALE':
                update_sale = request.form['UPDATE_SALE1']
                if update_sale.isnumeric()  :
                    try:
                        db.execute('SET SQL_SAFE_UPDATES = 0;')
                        db.execute('CALL update_sale({0});'.format(update_sale))
                        db.execute('SET SQL_SAFE_UPDATES = 1;')
                        session['msq_err']='Process Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                    return render_template("home_err.html")
                session['msq_err']="N0Nnumeric data typed"
                return render_template("home_err.html")  
            if request.form.get('UPDATE_SUPPLY') == 'UPDATE_SUPPLY':
                update_supply = request.form['UPDATE_SUPPLY1']
                print(update_supply)
                if update_supply.isnumeric()  :
                    try:
                        db.execute('SET SQL_SAFE_UPDATES = 0;')
                        db.execute('CALL update_supply({0});'.format(update_supply))
                        db.execute('SET SQL_SAFE_UPDATES = 1;')
                        session['msq_err']='Process Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                    return render_template("home_err.html")
                session['msq_err']="N0Nnumeric data typed"
                return render_template("home_err.html")  
    except:
        session['msq_err']="N0Nnumeric data typed"
        return render_template("home_err.html")





@app.route('/pythonlogin/home/select', methods=['GET', 'POST'])
def select():
    try:
        global select,id_name,columns_name
        select = request.form.get('tables')
        session['table']=select
        what = request.form['what']
        session['msq_err']='Bad syntax'
        if str(select)!='None'  and str(what) not in ['','None']:
            #join
            join_text=""
            join= request.form.get('join')
            tables_j = request.form.get('tables_j')
            on=request.form['on']
            if join not in ['','None'] and tables_j not in ['','None'] and on not in ['','None']:
                join_text=join+tables_j+str(' ON ') + on


            #rest
            condition = request.form['condition']
            group = request.form['group']
            having = request.form['having']
            order = request.form['order']
            limit = request.form['limit']
            strings = [[" WHERE ", condition],[" GROUP BY ",group],[" HAVING ",having],[" ORDER BY ",order],[" LIMIT ",limit]]
            rest_guerry=""
            for x in strings:
                if x[1] !="":
                    rest_guerry+=str(x[0])+str(x[1])
            
            try:
                session['msq_err']='Done'
                print("SELECT {0} FROM {1} {2} {3};".format(what,select,join_text,rest_guerry))
                df = pd.read_sql("SELECT {0} FROM {1} {2} {3};".format(what,select,join_text,rest_guerry), db) #read the entire table
                data=(df.to_dict('records'))
                id_name=str(df.columns[0])
                columns_name=df.columns.values.tolist()
                session['msq_err']='Done'
                return render_template('table.html',  contacts=data)
            except exc.SQLAlchemyError as e:
                session['msq_err']=str(e)
                return render_template("home_err.html")
    except:
        session['msq_err']="Some filds wronglly filled or empty."
        return render_template("home_err.html")

    return render_template("home.html")

@app.route('/pythonlogin/home/change', methods=['GET', 'POST'])
def change():  
    try:
        if request.method == 'POST': 
            if request.form.get('Delete') == 'Delete':
                for getid in request.form.getlist('mycheckbox'):
                    if select=='clients' or select=='suppliers' or select=='workers':
                        session['msq_err']='Cant delete clients/ suppliers/ workers! do do that operation. Delete user in users table!'
                    elif select=='users' or select=='products':
                        try:
                            db.execute('SET FOREIGN_KEY_CHECKS=0;')
                            db.execute('DELETE FROM {0} WHERE {1} = {2};'.format(select,id_name,getid))
                            db.execute('SET FOREIGN_KEY_CHECKS=1;')
                            session['msq_err']='Done'
                        except exc.SQLAlchemyError as e:
                            session['msq_err']=str(e)
                            return render_template("home_err.html")
                    else:
                        try:
                            db.execute('DELETE FROM {0} WHERE {1} = {2};'.format(select,id_name,getid))
                            session['msq_err']='Done'
                        except exc.SQLAlchemyError as e:
                            session['msq_err']=str(e)
                            return render_template("home_err.html")
                
                return redirect('/pythonlogin/home/change/select_after')


            if request.form.get('Edit') == 'Edit':
                id=[]
                for getid in request.form.getlist('mycheckbox'):
                    id.append(getid)
                try:
                    df = pd.read_sql("Select * from {0} where {1} in (".format(select,id_name)+', '.join(id)+');', db) #read the entire table
                    data=(df.to_dict('records'))
                    session['msq_err']='Done'
                    return render_template('table_update.html',  contacts=data)
                except exc.SQLAlchemyError as e:
                    session['msq_err']=str(e)
                    return render_template("home_err.html")
                                      
                
            if request.form.get('Add') == 'Add':
                try:
                    columns_name1=', '.join(columns_name)
                    session['msq_err']='Done'
                    return render_template('table_add.html', table=select,columns=columns_name1)
                except exc.SQLAlchemyError as e:
                    session['msq_err']=str(e)
                    return render_template("home_err.html")

        return render_template("home.html")
    except:
        return render_template("home_err.html")


@app.route('/pythonlogin/home/change/select_after')
def select_after():    
    df = pd.read_sql("Select * from {0};".format(select), db) #read the entire table
    data=(df.to_dict('records'))
    return render_template('table.html',  contacts=data)


@app.route('/pythonlogin/home/change/edit', methods=['GET', 'POST'])
def edit_all():   
    try:
        if request.method == 'POST': 
            if request.form.get('Edit_All') == 'Edit_All':

                for getid in request.form.getlist('mycheckbox'):

                    try:
                        column_add =request.form[str(getid)]
                        column_add =str(column_add.replace(" ", ""))
                        db.execute('UPDATE {0}  SET {1} WHERE {2} = {3};'.format(select,column_add,id_name,getid))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)

                return redirect('/pythonlogin/home/change/select_after')
    except:
        return render_template("home_err.html")

@app.route('/pythonlogin/home/change/add', methods=['GET', 'POST'])
def add_all():   
    try:
        if request.method == 'POST': 
            if request.form.get('Add_All') == 'Add_All':
                column_add = request.form['column_add']
                value_add = request.form['value_add']
                if select=='users':
                    try:
                        db.execute('CALL add_user_all({0});'.format(value_add))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                elif select=='products':        
                    try:
                        db.execute('CALL add_product({0},{1});'.format(value_add,'@LID'))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                elif select=='beers':
                    try:
                        db.execute('CALL add_beer({0});'.format(value_add))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                elif select=='wines':
                    try:
                        db.execute('CALL add_wine({0});'.format(value_add))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                elif select=='liquors':
                    try:
                        db.execute('CALL add_liquor({0});'.format(value_add))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                else:
                    try:
                        db.execute('INSERT INTO {0} ({1})  VALUES ({2});'.format(select,column_add,value_add))
                        session['msq_err']='Done'
                    except exc.SQLAlchemyError as e:
                        session['msq_err']=str(e)
                    
                return redirect('/pythonlogin/home/change/select_after')
        
    except:
        return render_template("home_err.html")

@app.route('/pythonlogin/home/backup', methods=['GET', 'POST'])
def backup():   
    try:
        if request.method == 'POST':
            if request.form.get('SAVE') == 'SAVE':
                # pass
                
                try:
                    subprocess.call('mysqldump --column-statistics=0 -u root -padmin liquors_warehouse > C:/Users/s1z2y/Desktop/pythonlogin/backup/backup_liquors_warehouse_1_web.sql', shell=True,  cwd='C:/Program Files/MySQL/MySQL Server 8.0/bin')
                    session['msq_err']='Process Done'
                    print("SAVE DATABASE")
                    return render_template("home_err.html")
                except:
                    return redirect(url_for('home')) 
            if  request.form.get('RESTORE') == 'RESTORE':
                # pass # do something else
                print("RESTORE DATABASE")
                try:
                    subprocess.call('mysql --column-statistics=0 -u root -padmin liquors_warehouse < C:/Users/s1z2y/Desktop/pythonlogin/backup/backup_liquors_warehouse_1_web.sql' , shell=True,  cwd='C:/Program Files/MySQL/MySQL Server 8.0/bin')
                    session['msq_err']='Process Done'
                    return render_template("home_err.html")
                except:
                    return redirect(url_for('home')) 
    except:
        return redirect(url_for('home')) 

@app.route('/pythonlogin/add_user_logg', methods=['GET', 'POST'])
def add_user_logg():
    print('sa')
    try:
        add_user_logg = request.form['add_user_logg']
        print(add_user_logg)
        if add_user_logg.isnumeric()  :
            try:
                db.execute('SELECT login_in,password_in,seed_in,role_in, email_in INTO  @v1, @v2, @v3,@v4 ,@v5 from loggings Where id={0};'.format(add_user_logg))
                db.execute('CALL add_user_all(@v1,@v2,@v3,@v4,NULL,NULL,NULL,NULL,@v5);')
                session['msq_err']='Process Done'
            except exc.SQLAlchemyError as e:
                session['msq_err']=str(e)
                return render_template("home_err.html")
        else:
            session['msq_err']="N0Nnumeric data typed"
        return render_template("home_err.html")
    except:
        return render_template("home_err.html")
 # http://localhost:5000/python/logout - this will be the logout page
@app.route('/pythonlogin/logout')
def logout():
    # Remove session data, this will log the user out
   session.pop('loggedin', None)
   session.pop('id', None)
   session.pop('username', None)
   session.pop('role', None)

   # Redirect to login page
   return redirect(url_for('login'))


# http://localhost:5000/pythinlogin/register - this will be the registration page, we need to use both GET and POST requests
@app.route('/pythonlogin/register', methods=['GET', 'POST'])
def register():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        role = request.form['role']
        # Check if account exists using MySQL
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM loggings WHERE login_in = %s', (username,))
        account = cursor.fetchone()
        # If account exists show error and validation checks
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password or not email or not role:
            msg = 'Please fill out the form!'
        else:
            seed=random.randint(1, 20)
            m=str.encode(str(password)+ str(seed))
            password_hash= hashlib.sha512(m).hexdigest()
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            cursor.execute('INSERT INTO loggings VALUES (NULL, %s, %s, %s,%s,%s)', (username, password_hash, email,role,seed,))
            mysql.connection.commit()
            msg = 'You have successfully registered! Please wait till we confirm your account.'
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
    # Show registration form with message (if any)
    return render_template('register.html', msg=msg)

# http://localhost:5000/pythinlogin/home - this will be the home page, only accessible for loggedin users
@app.route('/pythonlogin/home')
def home():
    # Check if user is loggedin
    if 'loggedin' in session:
        # User is loggedin show them the home page
        return render_template('home.html', username=session['username'])
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))


# http://localhost:5000/pythinlogin/profile - this will be the profile page, only accessible for loggedin users
@app.route('/pythonlogin/profile')
def profile():
    # Check if user is loggedin
    if 'loggedin' in session:
        # We need all the account info for the user so we can display it on the profile page
        account=  {'id': session['id'], 'username': session['username'], 'role': session['role']}

        # Show the profile page with account info
        return render_template('profile.html', account=account)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))


@app.errorhandler(404)
def not_found_error(error):
    return render_template('404.html'),404
 
#Handling error 500 and displaying relevant web page
@app.errorhandler(500)
def internal_error(error):
    return render_template('500.html'),500


if __name__ == '__main__':
    app.run(host='localhost', port=5000)