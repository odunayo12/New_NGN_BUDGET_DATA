# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import json
import csv
import tabula
#import camelot


# %%
df = tabula.read_pdf("C:/Users/rotim/OneDrive - bwedu/Data Project/BudgetData/PDF_Data/2019_Budget_As_Passed PDF.pdf",
                     lattice=True, multiple_tables=True, pages="all")


# %%
print(len(df))
df[4]


# %%
tabula.convert_into("C:/Users/rotim/OneDrive - bwedu/Data Project/BudgetData/PDF_Data/2019_Budget_As_Passed PDF.pdf",
                    "output2019.csv",  lattice=True,  output_format="csv", pages="all")


# %%
#tbl = "C:/Users/rotim/OneDrive - bwedu/Data Project/BudgetData/PDF_Data/2019_Budget_As_Passed PDF.pdf"


# %%
tbl2020 = "C:/Users/rotim/OneDrive - bwedu/Data Project/BudgetData/PDF_Data/2020_Executive_Budget_Proposal.pdf"
tbl2018 = "C:/Users/rotim/OneDrive - bwedu/Data Project/BudgetData/PDF_Data/2018_Executive_Proposal.pdf"
tbl2018_extract = tabula.convert_into(
    tbl2018, 'tbl2018_extract.csv',   lattice=True,  output_format="csv", pages="all")
tbl2020_extract = tabula.convert_into(
    tbl2020, 'tbl2020_extract.csv', output_format='csv', lattice=True)
# %%
# this works
tbl2020_extract = tabula.convert_into(
    "C:/Users/rotim/OneDrive - bwedu/Data Project/BudgetData/PDF_Data/2020_Executive_Budget_Proposal.pdf", 'tbl2018_extract.csv', stream=True,
    output_format="csv", pages="all")
# %%
pdf_2020 = tabula.read_pdf(tbl2020, multiple_tables=True)


# %%
pdf_2020


# %%

# %%
csvFilePath = "C:/Users/rotim/OneDrive - bwedu/Web Developmnet/data-analysis/New_NGN_BUDGET_DATA/Data/finished_sets/csv_/projects_18_19_20.csv"
jsonFilePath = "C:/Users/rotim/OneDrive - bwedu/Web Developmnet/data-analysis/New_NGN_BUDGET_DATA/Data/finished_sets/json_/projects_18_19_20.json"

# %%
data = {}


# %% read csv
with open(csvFilePath) as csvFile:
    csvReader = csv.DictReader(csvFile)
    for rows in csvReader:
        id = rows['id']
        data[id] = rows
# put data inside a root node
root = {}
root['project_item'] = data

# %% convert to json
with open(jsonFilePath, 'w') as jsonFile:
    jsonFile.write(json.dumps(root, indent=3))


# %%
# 2021
tabula.convert_into(r"..\PDF_Data\2021_BUDGET_PROPOSAL_FINAL.pdf", 'tbl2021_extract.csv', stream=True,
                    output_format="csv", pages="all")

# %%
