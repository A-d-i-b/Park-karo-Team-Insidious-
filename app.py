from flask import Flask, request, jsonify
from dynamic_pricing import predict

app = Flask(__name__)
@app.route('/', methods=['POST'])
def predict_amt():
    # Get data from the request
    data = request.get_json()

    # Use your machine learning model to make predictions
    prediction = predict(data)  # Replace with your model code
    
    # Return the prediction as a JSON response
    return jsonify({'prediction': prediction})


if __name__ == "__main__":
     app.run(debug=True ,port=8080,use_reloader=False)

