import numpy as np
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import joblib

def train_and_save_model():
    # Load dataset
    iris = load_iris()
    # x for measurements and y for flower label i.e. type of iris flower
    X, y = iris.data, iris.target

    # Split dataset into training and testing sets
    # 20% used for testing and 80% used for training the model. random_state=42 means maintain split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train a RandomForestClassifier
    # random_state=42 means maintain split
    # run this classification for 100 plants in the "forrest"
    clf = RandomForestClassifier(n_estimators=100, random_state=42)
    clf.fit(X_train, y_train)

    # Save the trained model
    joblib.dump(clf, 'model.joblib')

if __name__ == '__main__':
    train_and_save_model()
