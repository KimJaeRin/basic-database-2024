## 파이썬 DB 연동 프로그램
import sys
from PyQt5 import uic
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QCloseEvent
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
import webbrowser

## MSSQL 연동할 라이브러리(모듈)
import pymssql as db

## 전역변수(나중에 값 변경시 활용)
serverName = '127.0.0.1'
userID = 'sa'
userPass = 'mssql_p@ss'
dbname = 'Madang'
dbcharset = 'UTF8'

# 저장버튼 클릭시 삽입, 수정을 구분짓기위한 구분자
mode = 'I' # U I : Insert, U : Update

from PyQt5.QtWidgets import QWidget

class qtApp(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        uic.loadUi('./day06/MadangBook.ui', self)
        self.initUI()

    def initUI(self) -> None:
        # 입력제한
        self.txtBookid.setValidator(QIntValidator(self)) #숫자만 입력하도록 제한
        self.txtPrice.setValidator(QIntValidator(self)) #숫자만 입력하도록 제한
        #Button 4개에 대한 사용등록
        self.btnNew.clicked.connect(self.btnNewClicked) #신규버튼
        self.btnSave.clicked.connect(self.btnSaveClicked) # 저장버튼
        self.btnDel.clicked.connect(self.btnDelClicked) # 삭제버튼
        self.btnReload.clicked.connect(self.btnReloadClicked) # 조회버튼
        self.tblBooks.itemSelectionChanged.connect(self.tblBooksSelected) # 조회버튼
        self.show()
        self.btnReloadClicked() #조회버튼 클릭함수 실행
    
    def btnNewClicked(self):
        conn = db.connect(serverName, userID,userPass, dbname, charset = dbcharset)
        cursor = conn.cursor(as_dict=True)

        cursor.execute('SELECT * FROM Book')
        for row in cursor:
                print(f'bookid={row["bookid"]}, bookname={row["bookname"]}, publisher={row["publisher"]}, price={row["price"]}')
        
        global mode
        conn.close()
        mode = 'I'
        self.txtBookid.setText('')
        self.txtBookName.setText('')
        self.txtPublisher.setText('')
        self.txtPrice.setText('')
        self.txtBookId.setEnabled(True) # 사용
    
    def btnSaveClicked(self):
        # 입력검증(Validation Check) 반드시 
        # 1. 텍스트박스를 비워두고 저장버튼을 두르면 안됨
        bookid = self.txtBookid.text()
        bookName = self.txtBookName.text()
        publisher = self.txtPublisher.text()
        price = self.txtPrice.text()

        WarningMsg = '' #경고 메시지
        isValid = True #빈값이 있으면 False로 변경
        if bookid == None or bookid == '':
            WarningMsg += '책 번호가 없습니다.\n'
            isValid = False
        if bookName == None or bookName == '':
            WarningMsg += '책 제목이 없습니다.\n'
            isValid = False
        if publisher == None or publisher == '':
            WarningMsg += ' 출판사가 없습니다.\n'
            isValid = False
        if price == None or price == '':
            WarningMsg += ' 정가가 없습니다.\n'
            isValid = False
        
        if isValid == False: #위 입력값중에 하나라고 빈값이 존재
            QMessageBox.warning(self,'저장 경고',WarningMsg)

        ## mode = 'I'일때는 중복번호를 체크해야 하지만, mode = 'U'일때는 체크해서 막으면 수정자체가 안됨
        if mode == 'I':
            
            # 현재 존재하는 번호를 사용했는지 체크, 이미 있는 번호면 DB입력 쿼리 실행이 안되도록 막아야 함
            conn = db.connect(serverName, userID, userPass, dbname, charset = dbcharset)
            cursor = conn.cursor(as_dict=False) # COUNT (*)는 데이터가 딱 1개이기때문에 as_dict = False로 해야함
            
            query = f'''SELECT COUNT(*)
                        FROM Book
                        WHERE bookid = {bookid} '''
            cursor.execute(query)
            # print(cursor.fetchone()[0])
            valid = cursor.fetchone()[0]
            conn.close()
            
            if valid == 1: #DB Book테이블에 같은 번호가 이미 존재
                QMessageBox.warning(self, '저장 경고', '이미 같은 번호의 데이터가 존재합니다. \n번호를 변경하세요.')
                return #함수탈출

        ## 입력검증 후 DB Book테이블에 삽입 시작!
        #bookid, bookName, publisher, price
        if mode == 'I':
            query = f'''INSERT INTO Book
                   VALUES ({bookid}, '{bookName}', '{publisher}', {price})
                '''
        elif mode == 'U': # 수정
            query = f''' UPDATE Book
                            SET bookname = N'{bookName}'
                              , publisher = N'{publisher}'
                              , price = {price}
                          WHERE bookid = {bookid}  '''
            
        conn = db.connect(serverName, userID, userPass, dbname, charset = dbcharset)
        cursor = conn.cursor(as_dict=False) # INSERT는 데이터를 가져오는게 아니라서


        try:    
            cursor.execute(query)
            conn.commit() #저장을 확립

            if mode == 'I':
                QMessageBox.about(self, '저장 성공','데이터를 저장했습니다.')
            else:
                QMessageBox.about(self, '수정 성공','데이터를 수정했습니다.')
        except Exception as e:
            QMessageBox.warning(self, '저장 실패', f'{e}')
            conn.rollback() # 원상복귀
        finally:
            conn.close() #오류가 나든 안나든 db닫음
            
   

    
    def btnDelClicked(self): #삭제버튼 클릭
        # 삭제기능
        bookid = self.txtBookid.text()
        print(bookid)
        # Validatoin Check
        if bookid == None or bookid == '':
            QMessageBox.warning(self, '삭제 경고', '책 번호 없이 삭제할 수 없습니다.')
            return
        
        #삭제시에는 삭제여부를 물어보는게 좋음
        re = QMessageBox.question(self, '삭제 여부', '삭제하시겠습니까?', QMessageBox.Yes | QMessageBox.No)
        if re == QMessageBox.No:
            return
        
        conn = db.connect(serverName, userID, userPass, dbname, charset = dbcharset)
        cursor = conn.cursor(as_dict=True)

        query = f'''DELETE FROM Book
                     WHERE bookid = {bookid}  '''
        
        try:
            cursor.execute(query)
            conn.commit()

            QMessageBox.about(self, '삭제 성공','데이터를 삭제하였습니다')
        except Exception as e:
            QMessageBox.warning(self, '삭제  실패', f'{e}')
            conn.rollback() #원상복귀
        finally:
            conn.close # 오류가 나든 안나든 db 닫음.
    
    def btnReloadClicked(self): #조회버튼 클릭
        lstResult = []
        conn = db.connect(serverName, userID, userPass, dbname, charset = dbcharset)
        cursor = conn.cursor(as_dict=True)

        query = '''
                SELECT bookid
                    , bookname
                    , publisher
                    , ISNULL(FORMAT(price, '#,#'), '0') AS price
                FROM Book
                '''
        
        cursor.execute(query)
        for row in cursor:
                # print(f'bookid={row["bookid"]}, bookname={row["bookname"]}, publisher={row["publisher"]}, price={row["price"]}')
                # dictionary로 만든 결과를 lstResult에 append()
            temp = { 'bookid' : row["bookid"], 'bookname' : row["bookname"], 'publisher' : row["publisher"], 'price' : row["price"]}
            lstResult.append(temp)

        conn.close() # DB는 접속해서 일이 끝나면 무조건 닫는다.

        #print(lstResult) #tblBooks 테이블 위젯에 표시
        self.makeTable(lstResult)

    def makeTable(self, data): #tblBooks 위젯을 데이터와 컬럼 생성해주는 함수
        self.tblBooks.setColumnCount(4) #bookid, bookname, publisher, price
        self.tblBooks.setRowCount(len(data)) #조회에서 나온 리스트의 갯수로 결정
        self.tblBooks.setHorizontalHeaderLabels(['책 번호', ' 책 제목', '출판사', '정가']) #컬럼이름 설정

        n = 0
        for item in data:
            #print(item) 디버깅시 필요
            idItem = QTableWidgetItem(str(item['bookid']))
            idItem.setTextAlignment(Qt.AlignmentFlag.AlignRight | Qt.AlignmentFlag.AlignVCenter)
            self.tblBooks.setItem(n, 0, QTableWidgetItem(str(item["bookid"]))) # set(row, column, text), 문자가 아니기 때문에 str
            self.tblBooks.setItem(n, 1, QTableWidgetItem((item["bookname"])))
            self.tblBooks.setItem(n, 2, QTableWidgetItem(str(item["publisher"]))) 
            priceItem = QTableWidgetItem(str(item["price"]))
            priceItem.setTextAlignment(Qt.AlignmentFlag.AlignRight | Qt.AlignmentFlag.AlignVCenter)
            self.tblBooks.setItem(n, 3, priceItem) # set(row, Column, str type text)
            

            n += 1

        self.tblBooks.setColumnWidth(0,65) # 책번호 컬럼 넓이
        self.tblBooks.setColumnWidth(1,230) # 책번호 컬럼 넓이
        self.tblBooks.setColumnWidth(2,130) # 출판사 컬럼 넓이
        self.tblBooks.setColumnWidth(3,80) # 정가 컬럼 넓이
        #컬럼 더블클릭 금지
        self.tblBooks.setEditTriggers(QAbstractItemView.NoEditTriggers)



    def tblBooksSelected(self):
        rowIndex = self.tblBooks.currentRow() # 현재 마우스로 선택된 행의 인덱스
        #print(rowIndex)
        bookId = self.tblBooks.item(rowIndex, 0).text() #책 번호
        bookName = self.tblBooks.item(rowIndex, 1).text() #책 제목
        publisher = self.tblBooks.item(rowIndex, 2).text() # 출판사
        price = self.tblBooks.item(rowIndex, 3).text().replace(',', '') # 정가
        # lineEdit(TextBox)에 각각 할당
        self.txtBookid.setText(bookId)
        self.txtBookName.setText(bookName)
        self.txtPublisher.setText(publisher)
        self.txtPrice.setText(price)
        # 모드를 Update로 변경
        global mode # 전역변수를 내부에서 사용
        mode = 'U'
        #txtBookId를 사용하지 못하게 설정
        self.txtBookid.setEnabled(False)





    # 원래 PyQt에 있는 함수 closeEvent를 재정의(Override)
    def closeEvent(self, event) -> None:
        re = QMessageBox.question(self, '종료여부', '종료하시겠습니까?', QMessageBox.Yes | QMessageBox.No)
        if re == QMessageBox.Yes:
            event.accept()
        else:
            event.ignore()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    inst = qtApp()
    sys.exit(app.exec_())

    

