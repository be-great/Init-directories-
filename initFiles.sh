####################################
echo "Flask" > requirements.txt
### main.py ################
echo "import os
from webapp import create_app

env = os.environ.get('WEBAPP_ENV', 'dev') ## if is not in environment just return dev
app = create_app('config.%sConfig' % env.capitalize())


if __name__ == '__main__':
    app.run()
" > main.py

## init.sh #############################
echo "
if [ ! -d 'venv' ]; then
    echo --------------------
    echo Creating virtualenv
    echo --------------------
    virtualenv venv
fi
source venv/bin/activate
pip install -r requirements.txt
export FLASK_ENV=development
export FLASK_APP='main.py'
flask run " > init.sh
#####README.md#############
echo "Readme " > README.md
#### config file 
echo "import os

basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    SECRET_KEY = '736670cb10a600b695a55839ca3a5aa54a7d7356cdef815d2ad6e19a2031182b'
    POSTS_PER_PAGE = 10
    RECAPTCHA_PUBLIC_KEY = 'XXX'
    RECAPTCHA_PRIVATE_KEY = 'XXX'
    GOOGLE_CLIENT_ID = 'XXX'
    GOOGLE_CLIENT_SECRET = 'XXX'
class ProdConfig(Config):
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'database.db')
    RECAPTCHA_PUBLIC_KEY = '6LdKkQQTAAAAAEH0GFj7NLg5tGicaoOus7G9Q5Uw'
    RECAPTCHA_PRIVATE_KEY = '6LdKkQQTAAAAAMYroksPTJ7pWhobYb88fTAcxcYn'

class DevConfig(Config):
    DEBUG = True
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'database.db')
" > config.py 

#################################################################
mkdir webapp && cd webapp 
echo "from flask import Flask, render_template

def create_app(object_name):
 
    app = Flask(__name__)
    app.config.from_object(object_name)


    from .doctor import doctor_create_module
    from .paitent import paitent_create_module
    from .admin import admin_create_module
    from .main import main_create_module
    

    doctor_create_module(app)
    paitent_create_module(app)
    admin_create_module(app)
    main_create_module(app)

    return app
" > __init__.py
################################################################
# array declare 
declare -a arr=("doctor" "paitent" "admin" "main")


for i in "${arr[@]}"
do
   mkdir "$i"
   cd "$i"
   touch forms.py models.py
   echo  "def "$i"_create_module(app,**kwargs):
    from .view import "$i"_blueprint
    app.register_blueprint("$i"_blueprint)
"  > __init__.py
   echo "from flask import Blueprint, redirect, url_for, render_template

"$i"_blueprint = Blueprint(
    '$i',
    __name__,
    template_folder='../templates/"$i"',
    url_prefix="$i"
)


@"$i"_blueprint.route('/')
def index():
    return render_template('"$i".html'))
" > view.py
   cd ..
done

