import time
from selenium import webdriver
import chromedriver_binary
import datetime

driver = webdriver.Chrome()
driver.get('https://demotrade.highlow.com/')
driver.maximize_window()

sentTextArray = []
def txtRead():
    with open('./test.txt', mode='r+', encoding='utf-8') as f:
        sentTextArray.clear()
        for _ in range(1):
            lines = f.readline()
            line = lines.replace("\n", "")
            sentTextArray.append(line)
        f.truncate(0)
        f.close()

def selectTabElement():
    tabElement = driver.find_elements_by_class_name("tab")
    tabElement[1].click()

def searchTarget(data):
    pullDown = driver.find_elements_by_class_name("asset-filter--opener")
    pullDown[0].click()
    time.sleep(0.1)
    driver.find_element_by_id("searchBox").send_keys(data)
    time.sleep(0.15)
    driver.find_elements_by_class_name("asset_item")[0].click()

def setEntryPanel():
    hourArray = []
    minArray = []

    def getMaxIndex():
        if datetime.time(hourArray[0], minArray[0], 0) > datetime.time(hourArray[1], minArray[1], 0):
            if datetime.time(hourArray[0], minArray[0], 0) > datetime.time(hourArray[2], minArray[2], 0):
                return 0
            else:
                return 2
        elif datetime.time(hourArray[1], minArray[1], 0) > datetime.time(hourArray[2], minArray[2], 0):
            return 1
        else:
            return 2

    def getCenterIndex():
        if datetime.time(hourArray[0], minArray[0], 0) > datetime.time(hourArray[1], minArray[1], 0):
            if datetime.time(hourArray[1], minArray[1], 0) > datetime.time(hourArray[2], minArray[2], 0):
                return 1
            elif datetime.time(hourArray[0], minArray[0], 0) < datetime.time(hourArray[2], minArray[2], 0):
                return 0
            else:
                return 2
        elif datetime.time(hourArray[0], minArray[0], 0) > datetime.time(hourArray[2], minArray[2], 0):
            return 0
        elif datetime.time(hourArray[1], minArray[1], 0) > datetime.time(hourArray[2], minArray[2], 0):
            return 2
        else:
            return 1

    for i in range(3):
        timeInfo = driver.find_elements_by_class_name("time-digits")[i].text
        hourArray.append(int(timeInfo[0:2]))
        minArray.append(int(timeInfo[3:5]))

    driver.find_elements_by_class_name("instrument-panel-header")[getCenterIndex()].click()

def handleClickHidhLowBtn(type):
    if type == "up":
        driver.find_element_by_id("up_button").click()
    else:
        driver.find_element_by_id("down_button").click()

def setMoney(data):
    inputElement = driver.find_element_by_id("amount")
    inputElement.clear()
    inputElement.send_keys(data)

def handleClickBuyNowButton():
    driver.find_element_by_id("invest_now_button").click()

def registerAction():
    txtRead()
    selectTabElement()
    searchTarget(sentTextArray[0])
    time.sleep(1)
    setEntryPanel()
    handleClickHidhLowBtn(sentTextArray[2])
    setMoney(sentTextArray[1])
    handleClickBuyNowButton()

time.sleep(3)
registerAction()
# while True:
#     registerAction()
