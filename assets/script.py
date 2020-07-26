# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
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


# %%
tbl2020_extract = tabula.convert_into(
    tbl2020, 'tbl2020_extract.csv', output_format='csv', lattice=True)


# %%
pdf_2020 = tabula.read_pdf(tbl2020, multiple_tables=True)


# %%
pdf_2020
