
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # This will enable CORS for all routes

# Your existing routes and logic will go here
# For example:
@app.route('/')
def hello_world():
    return 'Hello, from your backend!'

if __name__ == '__main__':
    app.run(debug=True)
