
# Recursive Feature Elimination
from sklearn import datasets
from sklearn.feature_selection import RFE
from sklearn.linear_model import LogisticRegression
import pandas as pd 
import numpy
from sklearn.feature_selection import RFECV
from sklearn.datasets import make_classification
from sklearn.cross_validation import StratifiedKFold
from sklearn.svm import SVC




file='/Users/anam/Documents/First/Masters/UW/Thesis/WoundInf_Tests_Flattened.csv'
df = pd.read_csv(file, index_col= False)
df=df.fillna(0)
dataset = df
dataset = dataset.drop('Infection', 1)
# create a base classifier used to evaluate a subset of attributes
model = LogisticRegression()

rfecv = RFECV(estimator=model, step=10, cv=StratifiedKFold(df.Infection.values, 10),
              scoring="roc_auc")
rfecv = rfecv.fit(dataset, df.Infection.values)

print("AUC: %0.2f (+/- %0.2f) " % (rfecv.grid_scores_.mean(), rfecv.grid_scores_.std()))

print(rfecv.n_features_)

rfecv = RFECV(estimator=model, step=10, cv=StratifiedKFold(df.Infection.values, 10),
              scoring="accuracy")
rfecv = rfecv.fit(dataset, df.Infection.values)

print("Accuracy: %0.2f (+/- %0.2f) " % (rfecv.grid_scores_.mean(), rfecv.grid_scores_.std()))

print(rfecv.n_features_)


rfecv = RFECV(estimator=model, step=10, cv=StratifiedKFold(df.Infection.values, 10),
              scoring="precision")
rfecv = rfecv.fit(dataset, df.Infection.values)

print("Precision: %0.2f (+/- %0.2f) " % (rfecv.grid_scores_.mean(), rfecv.grid_scores_.std()))

print(rfecv.n_features_)


rfecv = RFECV(estimator=model, step=10, cv=StratifiedKFold(df.Infection.values, 10),
              scoring="recall")
rfecv = rfecv.fit(dataset, df.Infection.values)

print("Recall: %0.2f (+/- %0.2f) " % (rfecv.grid_scores_.mean(), rfecv.grid_scores_.std()))

print(rfecv.n_features_)

# rfe = RFE(model, 25,step=500)
# rfe = rfe.fit(dataset, df.Infection.values)
# summarize the selection of the attributes
# supportRFE=rfe.support_
# index=[i for i in range(len(supportRFE)) if supportRFE[i]==True]

# print(index)

# print(rfe.support_)
# print(rfe.ranking_)
