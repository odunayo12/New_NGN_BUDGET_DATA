# %%
import glob
import tabula
import urllib
import urllib.request
from bs4 import BeautifulSoup
import os
import json
import csv
import pandas
from dateutil.parser import ParserError
import re
from urllib.parse import urlparse
# %%


def make_soup(url):
    the_page = urllib.request.urlopen(url)
    soup_data = BeautifulSoup(the_page, 'html.parser')
    return soup_data


# %%
# TODO: write regex thst can capture 'RevenueM | 2014 | Over' in pdf_title_re as well as in and plus (r for revenue and ending 'download) in anchor_tag
limit = [0, 15, 30, 45]
soup_box = []
for each_item in limit:
    soup = make_soup(
        f'https://www.budgetoffice.gov.ng/index.php/2014-budget?start={each_item}')
    # print(soup)
    for target_list in soup.findAll("div", {"id": "edocman-documents"}):
        for each_list in target_list.findAll("h3"):
            for h3_list in each_list.findAll("a"):
                anchor_tag = h3_list.get('href')
                regex = re.compile(r'[\n\r\t/, ]')
                pdf_title_re = regex.sub("", h3_list.text) + '.pdf'
                if re.findall(r'RevenueM | 2014 | Over', pdf_title_re):
                    pdf_title_re = ""

                    #print(re.search('RevenueM', pdf_title_re).group())
                else:
                    pdf_title = pdf_title_re
                    soup_box.append(pdf_title_re)
                    # print(pdf_title)
                    # print(len(pdf_title))
                # get the last 8 characters of the anchor tag
                if anchor_tag[23] is not "r" and anchor_tag[-8:] == "download":
                    lead_domain = "https://www.budgetoffice.gov.ng"
                    # soup_box.append(lead_domain + anchor_tag)
                    pdf_file_dwnld = lead_domain + anchor_tag
                    #anchor_tag = h3_list.get('href')
                    #soup_box.append(pdf_file_dwnld + pdf_title)
                # directories
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
csv_import_files_dir = glob.glob(os.path.join(fileDir, '*.csv'))

dataframe_from_each_file = (pandas.read_csv(
    f, encoding='unicode-escape', error_bad_lines=False) for f in csv_import_files_dir)
concatenated_csv = pandas.concat(dataframe_from_each_file, ignore_index=True)
# %%
# soup_bowl = []
# years_s = [2014, 2015, 2016]
# limit = [0, 15, 30, 45]

# for each_stuff in years_s:
#     for each_item in limit:
#         soup = make_soup(
#             f'https://www.budgetoffice.gov.ng/index.php/{each_stuff}-budget?start={each_item}')
#         for target_list in soup.findAll("div", {"id": "edocman-documents"}):
#             for each_list in target_list.findAll("h3"):
#                 for h3_list in each_list.findAll("a"):
#                     anchor_tag = h3_list.get('href')
#                     regex = re.compile(r'[\n\r\t/, ]')
#                     pdf_title = regex.sub(
#                         "", h3_list.text) + f'{each_stuff}.pdf'
#                     #soup_bowl.append(pdf_title)
#                     if re.search('RevenueM', pdf_title_re):
#                         pdf_title_re = ""
#                         # soup_box.append()
#                         #print(re.search('RevenueM', pdf_title_re).group())
#                     else:
#                         pdf_title = pdf_title_re
#                         # print(pdf_title)
#                         # print(len(pdf_title))
#                     # get the last 8 characters of the anchor tag
#                     if anchor_tag[23] is not "r" and anchor_tag[-8:] == "download":
#                         lead_domain = "https://www.budgetoffice.gov.ng"
#                         # soup_box.append(lead_domain + anchor_tag)
#                         pdf_file_dwnld = lead_domain + anchor_tag
#                         #anchor_tag = h3_list.get('href')
#                         soup_box.append(pdf_file_dwnld + pdf_title)
#                     # directories
#                     fileDir = os.path.abspath(os.path.join(
#                     os.path.dirname('__file__'), '..', 'scrapped-files'))
#                     filepath = os.path.join(fileDir, pdf_title)
#                     # write to file
#                     pdf_file = open(filepath, "wb")
#                     pdf_file.write(urllib.request.urlopen(pdf_file_dwnld).read())
#                     pdf_file.close()

# # %%
# # directories
# import_files_dir = os.path.join(fileDir, '*.pdf')
# import_files = [
#     folder_content for folder_content in glob.glob(import_files_dir)]
# for each_stuff in years_s:
#     for pdf_filepath in import_files:
#         csv_filepath = os.path.join(pdf_filepath, f'{each_stuff}').replace('.pdf', '.csv')
#         tabula.convert_into(pdf_filepath, csv_filepath,
#                         lattice=True,  output_format="csv", pages="all")

# %%
