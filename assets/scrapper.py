# %%
import glob
import tabula
#import urllib
import urllib.request
import urllib3
from bs4 import BeautifulSoup
import os
import json
import csv
import pandas
from dateutil.parser import ParserError
import re
from urllib.parse import urlparse
import copy
# %%


def make_soup(url):
    #the_page = urllib.request.urlopen(url)
    the_page = urllib3.PoolManager().request('GET', url)
    #res = req.request('GET', url)
    #soup_data = BeautifulSoup(the_page)
    soup_data = BeautifulSoup(the_page, 'html.parser')
    return soup_data


# %%
limit = [0, 15, 30, 45]
soup_box = []
text_box = []
anchor_tag_box = []
for each_item in limit:
    soup = make_soup(
        f'https://www.budgetoffice.gov.ng/index.php/2014-budget?start={each_item}')
    # print(soup)
    for target_list in soup.findAll("div", {"id": "edocman-documents"}):
        for each_list in target_list.findAll("h3"):
            for h3_list in each_list.findAll("a"):
                anchor_tag = h3_list.get('href')
                html_text = h3_list.text
                regex = re.compile(r'[\n\r\t/, ]')
                pdf_title_re = (regex.sub("", html_text) + '.pdf')
                # text_box.append(pdf_title_re)
                # anchor_tag_box.append(anchor_tag)

                if re.findall(r'(RevenueM|2014|Over|StatutoryTransfersDebtService.pdf$)', str(pdf_title_re)):
                    pdf_title_re = ""
                else:
                    pdf_title = pdf_title_re
                    soup_box.append(pdf_title)

                if re.findall(r'(service/|/rev|t/2014|t/over)', str(anchor_tag)):
                    anchor_tag = ""
                else:
                    anchor_tag_new = anchor_tag
                    lead_domain = "https://www.budgetoffice.gov.ng"
                    pdf_file_dwnld = lead_domain + anchor_tag_new
                    anchor_tag_box.append(pdf_file_dwnld)
                # Directories
                fileDir = os.path.abspath(os.path.join(
                    os.path.dirname('__file__'), '..', 'scrapped-files'))
                filepath = os.path.join(fileDir, pdf_title)
                # write to file
                pdf_file = open(filepath, "wb")
                pdf_file.write(urllib.request.urlopen(pdf_file_dwnld).read())
                pdf_file.close()

# %%
# directories
import_files_dir = os.path.join(fileDir, '*.pdf')
import_files = [
    folder_content for folder_content in glob.glob(import_files_dir)]
# convert to csv
for pdf_filepath in import_files:
    csv_filepath = pdf_filepath.replace('.pdf', '.csv')
    tabula.convert_into(pdf_filepath, csv_filepath,
                        lattice=True,  output_format="csv", pages="all")

# %%
# TODO: Merge csv files
csv_array = []
fileDir = os.path.abspath(os.path.join(
    os.path.dirname('__file__'), '..', 'scrapped-files'))
fileDir_2014 = os.path.join(fileDir, '2014')
csv_import_files_dir = glob.glob(os.path.join(fileDir, '*.csv'))
df_from_file = [item for item in csv_import_files_dir]

for each_file in df_from_file:
    csv_merge = pandas.read_csv(each_file, encoding='cp1252')
    # , sep = ',', encoding = 'unicode_escape', error_bad_lines = False
    csv_merge['file'] = each_file.split('/')[-1]
    csv_array.append(csv_merge)

all_merged = pandas.concat(csv_array)
all_merged.to_csv(os.path.join(fileDir_2014, '2014_budget_raw.csv'))


# %%
limit = [0, 15, 30, 45]
year_in = 2017
soup_box = []
text_box = []
anchor_tag_box = []
for each_item in limit:
    soup = make_soup(
        # https: // www.budgetoffice.gov.ng/index.php/2017-approved-budget?start=0
        f'https://www.budgetoffice.gov.ng/index.php/{year_in}-approved-budget?start={each_item}')
    # print(soup)
    for target_list in soup.findAll("div", {"id": "edocman-documents"}):
        for each_list in target_list.findAll("h3"):
            for h3_list in each_list.findAll("a"):
                anchor_tag = h3_list.get('href')
                html_text = h3_list.text
                regex = re.compile(r'[\n\r\t/, ]')
                pdf_title_re = (regex.sub("", html_text) + f'{year_in}.pdf')
                text_box.append(pdf_title_re)
                anchor_tag_box.append(anchor_tag)

                lead_domain = "https://www.budgetoffice.gov.ng"
                pdf_file_dwnld = lead_domain + anchor_tag
                # if re.findall(r'(Prices|^2015|Over|Consolidated)', str(pdf_title_re)):
                #     pdf_title_re = ""
                # else:
                #     pdf_title = pdf_title_re
                #     soup_box.append(pdf_title_re)

                # if re.findall(r'(-analysis/|/consol|t/over|/2015-a|t/prices)', str(anchor_tag_box)):
                #     anchor_tag = ""
                # else:
                #     anchor_tag_new = anchor_tag
                #     lead_domain = "https://www.budgetoffice.gov.ng"
                #     pdf_file_dwnld = lead_domain + anchor_tag_new
                #     anchor_tag_box.append(pdf_file_dwnld)
                # Directories
                fileDir = os.path.abspath(os.path.join(
                    os.path.dirname('__file__'), '..', 'scrapped-files'))
                filepath = os.path.join(fileDir, pdf_title_re)
                # write to file
                pdf_file = open(filepath, "wb")
                pdf_file.write(urllib.request.urlopen(pdf_file_dwnld).read())
                pdf_file.close()
# %%
soup_bowl = []
years_s = [2014, 2015, 2016, 2017]
limit = [0, 15, 30, 45]
soup_box = []
text_box = []
anchor_tag_box = []
for each_year in years_s:
    for each_item in limit:
        if each_year != 2017:
            soup = make_soup(
                f'https://www.budgetoffice.gov.ng/index.php/{each_year}-budget?start={each_item}')
            for target_list in soup.findAll("div", {"id": "edocman-documents"}):
                for each_list in target_list.findAll("h3"):
                    for h3_list in each_list.findAll("a"):
                        anchor_tag = h3_list.get('href')
                        html_text = h3_list.text
                        anchor_tag_year = anchor_tag[11:15]
                        soup_bowl.append(anchor_tag_year)
                        regex = re.compile(r'[\n\r\t/, ]')
                        pdf_title_re = (
                            regex.sub("", html_text) + f'_{anchor_tag_year}.pdf')
                        # print(pdf_title_re)

                        text_box.append(pdf_title_re)
                        anchor_tag_box.append(anchor_tag)

                        # if re.findall(r'(?<=Rev|Sta)[a-zA-Z]+(e|n)2014|(?<=2014)\w+|(?<=2015|2016)App|Total|BudgetandtheStrategicI', str(pdf_title_re)):
                        #     pdf_title_re = ""
                        # else:
                        #     pdf_title = pdf_title_re
                        #     soup_box.append(pdf_title)

                        # if re.findall(r'(?<=/index.php/(2014|2015|2016)-budget/)overv|prices|approp|analysis|consol', str(anchor_tag)):
                        #     anchor_tag = ""
                        # else:
                        #     anchor_tag_new = anchor_tag
                        #     lead_domain = "https://www.budgetoffice.gov.ng"
                        #     pdf_file_dwnld = lead_domain + anchor_tag_new
                        #     anchor_tag_box.append(pdf_file_dwnld)
        # elif each_year==2017:
        #     soup = make_soup(
        #         f'https://www.budgetoffice.gov.ng/index.php/{each_year}-approved-budget?start={each_item}')
        #     #soup.append(copy.copy(soup_2))
        #     #soup_box.append(soup.append(copy.copy(soup_2)))
        #     for target_list in soup.findAll("div", {"id": "edocman-documents"}):
        #         for each_list in target_list.findAll("h3"):
        #             for h3_list in each_list.findAll("a"):
        #                 anchor_tag = h3_list.get('href')
        #                 html_text = h3_list.text
        #                 anchor_tag_year = anchor_tag[11:15]
        #                 print(anchor_tag_year)
        #                 soup_bowl.append(anchor_tag_year)
                        # for each_tag in anchor_tag:
                        #     anchor_tag_year = each_tag[11:15]
                        #     print(anchor_tag_year)
                        # regex = re.compile(r'[\n\r\t/, ]')
                        # pdf_title_re = (
                        #     regex.sub("", html_text) + f'{anchor_tag_year}.pdf')
                        # # if each_year == 2017 or each_year == 2014:
                        # #     pdf_title_re = (
                        # #         regex.sub("", html_text) + f'{year_in}.pdf')
                        # # else:
                        # #     pdf_title_re = (
                        # #         regex.sub("", html_text) + '.pdf')
                        # #edocman-documents > div:nth-child(1) > div:nth-child(1) > div.edocman-box-heading.clearfix > h3 > a
                        # #edocman-documents > div:nth-child(1) > div:nth-child(2) > div.edocman-box-heading.clearfix > h3 > a
                        # #edocman-category > h1 > i
                        # text_box.append(pdf_title_re)
                        # anchor_tag_box.append(anchor_tag)

                        # lead_domain = "https://www.budgetoffice.gov.ng"
                        # pdf_file_dwnld = lead_domain + anchor_tag
                        # # if re.findall(r'(Prices|^2015|Over|Consolidated)', str(pdf_title_re)):
                        # #     pdf_title_re = ""
                        # # else:
                        # #     pdf_title = pdf_title_re
                        # #     soup_box.append(pdf_title_re)

                        # # if re.findall(r'(-analysis/|/consol|t/over|/2015-a|t/prices)', str(anchor_tag_box)):
                        # #     anchor_tag = ""
                        # # else:
                        # #     anchor_tag_new = anchor_tag
                        # #     lead_domain = "https://www.budgetoffice.gov.ng"
                        # #     pdf_file_dwnld = lead_domain + anchor_tag_new
                        # #     anchor_tag_box.append(pdf_file_dwnld)
                        # # Directories
                        # fileDir = os.path.abspath(os.path.join(
                        #     os.path.dirname('__file__'), '..', 'scrapped-files'))
                        # filepath = os.path.join(fileDir, pdf_title_re)
                        # # write to file
                        # pdf_file = open(filepath, "wb")
                        # pdf_file.write(urllib.request.urlopen(pdf_file_dwnld).read())
                        # pdf_file.close()


# # %%
# # directories
# import_files_dir = os.path.join(fileDir, '*.pdf')
# import_files = [
#     folder_content for folder_content in glob.glob(import_files_dir)]
# for each_year in years_s:
#     for pdf_filepath in import_files:
#         csv_filepath = os.path.join(pdf_filepath, f'{each_year}').replace('.pdf', '.csv')
#         tabula.convert_into(pdf_filepath, csv_filepath,
#                         lattice=True,  output_format="csv", pages="all")

# %%
# https://stackoverflow.com/questions/3640359/regular-expressions-search-in-list
# https://stackoverflow.com/questions/24016988/how-to-extract-slug-from-url-with-regular-expression-in-python
#print(re.search('RevenueM', pdf_title_re).group())
# r = re.compile('(RevenueM|2014|Over|StatutoryTransfersDebtService.pdf$)')
# new_list = re.sub(r, '', str(soup_box))
# print(new_list)
# %%
# 2014
# ^(RevenueM|Statutory)[a-zA-Z]2014.pdf$
newlist = re.findall(
    r'(?<=Rev|Sta)[a-zA-Z]+(e|n)2014|(?<=2014)\w+|(?<=2015|2016)App|Total|BudgetandtheStrategicI', str(text_box))
# list(filter(r.match, str(anchor_tag_box)))
print(len(newlist))
print(newlist)


newlist_2 = re.findall(
    r'(?<=/index.php/(2014|2015|2016)-budget/)overv|prices|approp|analysis|consol', str(anchor_tag_box))
# list(filter(r.match, str(anchor_tag_box)))
print(len(newlist_2))
print(newlist_2)
# %%
# 2015
# r = re.compile(r'(service/|/consol|t/over)')
# if re.findall(r'(Prices|^2015|Over|Consolidated)', str(pdf_title_re)):
# newlist = re.findall(
#     r'(-analysis/|/consol|t/over|/2015-a|t/prices)', str(anchor_tag_box))
# # list(filter(r.match, str(anchor_tag_box)))
# print(newlist)
# %%
# 2106
newlist = re.findall(
    r'(Over|2016App|Total)', str(text_box))
# list(filter(r.match, str(anchor_tag_box)))
print(newlist)


newlist_2 = re.findall(
    r'(t/2016-a|/total-capital|t/overview-)', str(anchor_tag_box))
# list(filter(r.match, str(anchor_tag_box)))
print(newlist_2)

# %%
# 2107
newlist = re.findall(
    r'(2017App)', str(text_box))
# list(filter(r.match, str(anchor_tag_box)))
print(newlist)

newlist_2 = re.findall(
    r'(t/2017-a)', str(anchor_tag_box))
# list(filter(r.match, str(anchor_tag_box)))
print(newlist_2)

# %%
