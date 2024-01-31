from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from webdriver_manager.chrome import ChromeDriverManager

from ftplib import FTP_TLS
import ssl
import os
import time

user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"
options = webdriver.ChromeOptions()
options.add_argument('--headless=new')
options.add_argument("window-size=1920x1080")
options.add_argument(f"user-agent={user_agent}")
driver = webdriver.Chrome(service=Service(
    ChromeDriverManager().install()), options=options)

# 웹사이트 접속
driver.get('https://hosting.cafe24.com/?controller=new_member&method=login&sec=on&ref=%2F%3Fcontroller%3Dmyservice_hosting_main')

# 카페 24 로그인 
# username = driver.find_element(By.ID, 'loginId')  
# password = driver.find_element(By.ID, 'loginPasswd')  
# username.send_keys('gvgurbanstore')
# password.send_keys('iLq-ILS-3pi-ifb')
# print(f'{username}로 접속')

# login_button = driver.find_element(By.ID, 'idLoginBtn')  
# login_button.click()
# print(f'{login_button}클릭 로그인')
# pass_btn = driver.find_element(By.ID, 'iptBtnEm')  
# pass_btn.click()
# print(f'{pass_btn} 다음에 변경')

# backup_link = driver.find_element(By.LINK_TEXT, '백업받기/올리기')
# backup_link.click()
# print(f'{backup_link} 클릭')

# radio_btn=driver.find_element(By.NAME,'mssqlDbIdx')
# call_DB=driver.find_element(By.ID,'btnBackup')
# print(f'{call_DB} 성공')

# print(f'20분 대기')
# time.sleep(1000)
#========================================
#===============FTP 접속=================
#========================================

print(f'FTP 연결 시작')
# FTP 서버 정보
ftp_server = 'sqlftp-001.cafe24.com'
ftp_user = 'gvgurbanstore'
ftp_passwd = 'iLq-ILS-3pi-ifb'
ftp_port = 3822  
#SSL 콘텐트 생성
context = ssl.SSLContext(ssl.PROTOCOL_TLS)
context.options |= ssl.OP_NO_SSLv2  # SSLv2 비활성화
context.options |= ssl.OP_NO_SSLv3  # SSLv3 비활성화

# FTP 서버에 연결
ftp = FTP_TLS(context=context)
ftp.connect(host=ftp_server, port=ftp_port)
ftp.login(user=ftp_user, passwd=ftp_passwd)
ftp.prot_p()
print(f'{ftp_user} FTP 연결 성공')

# 서버 파일 목록을 가져옴
files = ftp.nlst()
print(f'{files} 파일목록')

# 가장 최근에 수정된 파일 찾기(맥스메소드(파라미터 x  사용 ->sendcmd()내에 x 매칭 후 최근 숫자 찾기))
latest_file = max(files, key=lambda x: ftp.sendcmd('MDTM ' + x))

# 최신 파일을 로컬에 다운로드
save_path = 'C:\\Users\\hanaseo\\Desktop\\DB_backup'
with open(os.path.join(save_path, latest_file), 'wb') as f:
    ftp.retrbinary('RETR ' + latest_file, f.write)
print(f'DB_backup 로컬에 저장완료')
# FTP 서버와 연결 종료
ftp.quit()