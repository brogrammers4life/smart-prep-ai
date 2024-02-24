import numpy as np
import pandas as pd
from pyBKT.models import Model

# Initialize the pyBKT model
model = Model(seed=42, num_fits=1, parallel=True)

# Fetch Assistments and CognitiveTutor data to the local disk
model.fetch_dataset(
    "https://raw.githubusercontent.com/CAHLR/pyBKT-examples/master/data/as.csv", "."
)
model.fetch_dataset(
    "https://raw.githubusercontent.com/CAHLR/pyBKT-examples/master/data/ct.csv", "."
)

# Fit the model
model.fit(data_path='ct.csv')

# Save the model as a pickle file
import pickle
with open('bkt_model.pkl', 'wb') as model_file:
    pickle.dump(model, model_file)
