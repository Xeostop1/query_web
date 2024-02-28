from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import subprocess
import time


user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"
options = webdriver.ChromeOptions()
# options.add_argument('--headless=new')
options.add_argument("window-size=1920x1080")
options.add_argument(f"user-agent={user_agent}")
driver = webdriver.Chrome(service=Service(
    ChromeDriverManager().install()), options=options)

# 웹사이트 접속
driver.get('https://www.ksbed.co.kr/goods/goods_list.php?cateCd=002&sort=&pageNum=40#')


login_button = driver.find_element(By.ID, 'idLoginBtn')  
login_button.click()
print(f'login_button 클릭 로그인')

try:
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, 'iptBtnEm')))
    pass_btn = driver.find_element(By.ID, 'iptBtnEm')
    pass_btn.click()
    print(f'비밀번호 다음에 변경')

    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.LINK_TEXT, '백업받기/올리기')))
    backup_link = driver.find_element(By.LINK_TEXT, '백업받기/올리기')
    backup_link.click()
    print(f'{backup_link} 클릭')

    radio_btn=driver.find_element(By.NAME,'mssqlDbIdx')
    radio_btn.click()
    call_DB=driver.find_element(By.ID,'btnBackup')
    call_DB.click()
    print(f'{call_DB} 성공')
except NoSuchElementException:
    print("iptBtnEm 요소가 없습니다. 백업받기/올리기로 이동합니다.")
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.LINK_TEXT, '백업받기/올리기')))
    backup_link = driver.find_element(By.LINK_TEXT, '백업받기/올리기')
    backup_link.click()
    print(f'{backup_link} 클릭')

    radio_btn=driver.find_element(By.NAME,'mssqlDbIdx')
    radio_btn.click()
    call_DB=driver.find_element(By.ID,'btnBackup')
    call_DB.click()
    print(f'{call_DB} 성공')

# pass_btn = driver.find_element(By.ID, 'iptBtnEm')  
# pass_btn.click()
# print(f'{pass_btn} 다음에 변경')

print(f'20분 대기')
time.sleep(1000)
#========================================
#===============FTP exe 실행=================
#========================================

print(f'파일질러 실행')
subprocess.Popen(["C:\\Program Files\\FileZilla FTP Client\\filezilla.exe"])
