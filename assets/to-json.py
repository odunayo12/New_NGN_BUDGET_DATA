# %%
import itertools
import pandas as pd
import json
# %%
data_json = pd.read_csv(
    r"C:\Users\rotim\OneDrive - bwedu\Web Developmnet\data-analysis\New_NGN_BUDGET_DATA\Budget_Data\summary\mda_by_year.csv", dtype=str)

# %%

data_json["year_id"] = data_json[['Year', 'costCenter_Code']].apply(
    lambda x: ''.join(str(x)), axis=1)
# %%


def get_nested_rec(key, grp):
    rec = {}
    rec['year_id'] = key[0]
    rec['costCenter_Code'] = key[1]
    rec['costCenter_Code_MDA'] = key[2]
    rec['Year'] = key[3]

    for field in ['table_identifier', 'table_identifier_MDA']:
        rec[field] = list(grp[field].unique())

    return rec


# %%
records = []
for key, grp in data_json.groupby(['year_id', 'costCenter_Code', 'costCenter_Code_MDA', 'Year']):
    rec = get_nested_rec(key, grp)
    records.append(rec)

records = dict(data=records)

# print(json.dumps(records, indent=4))
with open('data.json', 'w', encoding='utf-8') as f:
    json.dump(records, f, ensure_ascii=False, indent=4)
# %%
