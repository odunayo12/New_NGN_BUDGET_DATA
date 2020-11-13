# %%
import glob
import tabula
import urllib
import urllib.request
#import urllib3
from bs4 import BeautifulSoup
import os
import json
import csv
import pandas
from dateutil.parser import ParserError
import re
from urllib.parse import urlparse
import copy
from datetime import datetime
# %%
startTime = datetime.now()


def make_soup(url):
    the_page = urllib.request.urlopen(url)
    #the_page = urllib3.PoolManager().request('GET', url)
    #res = req.request('GET', url)
    #soup_data = BeautifulSoup(the_page)
    soup_data = BeautifulSoup(the_page, 'html.parser')
    return soup_data


def save_file(pdf_name, download_url):
    # Directories
    fileDir = os.path.abspath(os.path.join(
        os.path.dirname('__file__'), '..', 'scrapped-files'))
    filepath = os.path.join(fileDir, pdf_name)
    # write to file
    pdf_file = open(filepath, "wb")
    pdf_file.write(urllib.request.urlopen(download_url).read())
    pdf_file.close()


def save_file_to_dir(pdf_name, download_url, loop_year):
    # Directories
    fileDir = os.path.abspath(os.path.join(
        os.path.dirname('__file__'), '..', 'scrapped-files', str(loop_year)))
    filepath = os.path.join(fileDir, pdf_name)
    # write to file
    pdf_file = open(filepath, "wb")
    pdf_file.write(urllib.request.urlopen(download_url).read())
    pdf_file.close()


# %%
soup_bowl = []
years_s = [2014, 2015, 2016, 2017]
limit = [0, 15, 30, 45]
soup_box = []
text_box = []
anchor_tag_box = []
anchor_tag_box_2 = []
for each_year in years_s:
    for each_item in limit:
        if each_year != 2017:
            soup = make_soup(
                f'https://www.budgetoffice.gov.ng/index.php/{each_year}-budget?start={each_item}')
            # soup_div_id = soup.findAll("div", {"id": "edocman-documents"})
            # extract_id(soup_div_id)
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
                        # scrapped-files\2015\NationalSalariesIncomesAndWagesCommission2015_2015.pdf
                        # 'https://www.budgetoffice.gov.ng/index.php/2015-budget/national-salaries-incomes-and-wages-commission-2015/download',
                        text_box.append(pdf_title_re)
                        anchor_tag_box_2.append(anchor_tag)
                        title_pattern = re.compile(
                            r'(?<=Rev|Sta)[a-zA-Z]+(e|n)_2014|(?<=2014)\w+|(?<=2015|2016)App|Total|BudgetandtheStrategicI|FederalMinistryofTourismCulture&NOA2015|NationalSalariesIncomesAndWagesCommission2015_2015')
                        anchor_pattern = re.compile(
                            r'(?<=/index.php/(2014|2015|2016)-budget/)overv|prices|approp|analysis|consol|culture-noa-2015|wages-commission-2015')
                        if re.findall(title_pattern, str(pdf_title_re)) or re.findall(anchor_pattern, str(anchor_tag)):
                            pdf_title_re = ""
                            anchor_tag = ""
                        else:
                            pdf_title_work = pdf_title_re
                            soup_box.append(pdf_title_work)
                            # print(len(pdf_title_work))
                            anchor_tag_new = anchor_tag
                            lead_domain = "https://www.budgetoffice.gov.ng"
                            pdf_file_dwnld = lead_domain + anchor_tag_new
                            anchor_tag_box.append(pdf_file_dwnld)
                        # save pdf files
                            if pdf_title_work.rsplit("_", 1)[1][:4] == str(each_year):
                                save_file_to_dir(pdf_title_work,
                                                 pdf_file_dwnld,
                                                 each_year)
        else:
            soup = make_soup(
                f'https://www.budgetoffice.gov.ng/index.php/{each_year}-approved-budget?start={each_item}')
            # soup.append(copy.copy(soup_2))
            # soup_box.append(soup.append(copy.copy(soup_2)))
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
                        anchor_tag_box_2.append(anchor_tag)

                        if re.findall(r'(2017App)', str(pdf_title_re)) or re.findall(r'(t/2017-a)', str(anchor_tag)):
                            pdf_title_re = ""
                            anchor_tag = ""
                        else:
                            pdf_title_work = pdf_title_re
                            soup_box.append(pdf_title_re)
                            # print(len(pdf_title_work))
                            anchor_tag_new = anchor_tag
                            lead_domain = "https://www.budgetoffice.gov.ng"
                            pdf_file_dwnld = lead_domain + anchor_tag_new
                            anchor_tag_box.append(pdf_file_dwnld)
                        # save pdf files
                        # pyright: reportUnboundVariable=false
                        if pdf_title_work.rsplit("_", 1)[1][:4] == str(each_year):
                            save_file_to_dir(pdf_title_work,
                                             pdf_file_dwnld,
                                             each_year)

# %%
# Convert PDF to CSV
csv_array = []
for each_year in years_s:
    fileDir = os.path.abspath(os.path.join(
        os.path.dirname('__file__'),
        '..',
        'scrapped-files',
        str(each_year)))
    # print(fileDir)
    pdf_import_files_dir = glob.glob(os.path.join(fileDir, '*.pdf'))
    # print(pdf_import_files_dir)
    #df_from_file = [item for item in pdf_import_files_dir]
    # print(len(df_from_file))
    print(len(pdf_import_files_dir))
    for pdf_file_path in pdf_import_files_dir:
        csv_file_path = pdf_file_path.replace('.pdf', '.csv')
        tabula.convert_into(pdf_file_path, csv_file_path,
                            lattice=True, output_format='csv', pages='all')


# %%
def merge_all_files_in_folder(folder_name):
    """
    concatenate all files in dir
    """
    folder_name = str(folder_name)
    csv_array = []
    fileDir = os.path.abspath(os.path.join(
        os.path.dirname('__file__'),
        '..',
        'scrapped-files',
        folder_name))
    csv_import_files_dir = glob.glob(os.path.join(fileDir, '*.csv'))
    for each_file in csv_import_files_dir:
        csv_merge = pandas.read_csv(each_file, encoding='cp1252')
        csv_merge['file'] = each_file.split('/')[-1]
        csv_array.append(csv_merge)

    all_merged = pandas.concat(csv_array)
    all_merged.to_csv(os.path.join(
        fileDir, f'{folder_name}_budget_raw.csv'))


# %%
years_s = [2014, 2015, 2016, 2017]
for year_ in years_s:
    merge_all_files_in_folder(year_)

# %%
print(datetime.now() - startTime)
