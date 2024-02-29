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
# 바로 40 view로 넘어가서 시작

# 이름
# item_detail_tit h3
# 이거 클릭plus_review_num_tit
# 3번째 li
# strong
# 뒤로가기 누르고 







user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"
options = webdriver.ChromeOptions()
# options.add_argument('--headless=new')
options.add_argument("window-size=1920x1080")
options.add_argument(f"user-agent={user_agent}")
driver = webdriver.Chrome(service=Service(
    ChromeDriverManager().install()), options=options)


wait = WebDriverWait(driver, 10)
# 웹사이트 접속
driver.get('https://www.ksbed.co.kr/goods/goods_list.php?cateCd=002&sort=&pageNum=40#')

gallery = wait.until(EC.presence_of_element_located((By.CLASS_NAME, 'item_gallery_type')))
print(f'gallery 찾기 성공')

links = gallery.find_elements(By.CSS_SELECTOR, 'ul li .item_photo_box a')
print(f'links 찾기 성공')
for i in range(len(links)):
    # 매번 새롭게 요소찾기(페이지 변경때문에)
    links = gallery.find_elements(By.CSS_SELECTOR, 'ul li .item_photo_box a')
    # i번째 요소를 클릭합니다.
    links[i].click()  

    pcs_name = driver.find_element(By.CSS_SELECTOR, '.item_detail_tit h3').text
    print("상품명: ", pcs_name)

    hits = driver.find_element(By.CSS_SELECTOR, '.plus_review_num_tit ul li:last-child strong').text


    print("조회수: ", hits)

    # 원래 페이지 돌아오기
    driver.back()  
    print("원래 페이지 돌기")

print("완료")
