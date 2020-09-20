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
                pdf_title = regex.sub("", h3_list.text) + '.pdf'
                # get the last 8 characters of the anchor tag
                if anchor_tag[23] is not "r" and anchor_tag[-8:] == "download":
                    lead_domain = "https://www.budgetoffice.gov.ng"
                    # soup_box.append(lead_domain + anchor_tag)
                    pdf_file_dwnld = lead_domain + anchor_tag
                    soup_box.append(pdf_file_dwnld)
                # directories
                fileDir = os.path.abspath(os.path.join(
                    os.path.dirname('__file__'), '..', 'scrapped-files'))
                filepath = os.path.join(fileDir, pdf_title)
                # write to file
                pdf_file = open(filepath, "wb")
                pdf_file.write(urllib.request.urlopen(pdf_file_dwnld).read())
                pdf_file.close()
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
soup_box = []
years_s = [2014, 2015, 2016]
limit = [0, 15, 30, 45]

for each_stuff in years_s:
    for each_item in limit:
        soup = make_soup(
            f'https://www.budgetoffice.gov.ng/index.php/{each_stuff}-budget?start={each_item}')
        for target_list in soup.findAll("div", {"id": "edocman-documents"}):
            for each_list in target_list.findAll("h3"):
                for h3_list in each_list.findAll("a"):
                    anchor_tag = h3_list.get('href')
                    regex = re.compile(r'[\n\r\t/, ]')
                    pdf_title = regex.sub(
                        "", h3_list.text) + f'{each_stuff}.pdf'

# %%
