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

from PyQt5.QtWidgets import QWidget

class qtApp(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        uic.loadUi('./day05/MadangBook.ui', self)
        self.initUI()

    def initUI(self) -> None:
        #Button 4개에 대한 사용등록
        self.btnNew.clicked.connect(self.btnNewClocked) #신규버튼
        self.btnSave.clicked.connect(self.btnSaveClocked) # 저장버튼
        self.btnDel.clicked.connect(self.btnDelClocked) # 삭제버튼
        self.btnReload.clicked.connect(self.btnReloadClocked) # 조회버튼
        self.tblBooks.itemSelectionChanged.connect(self.tblBooksSelected) # 조회버튼
        self.show()
    
    def btnNewClocked(self):
        QMessageBox.about(self, '신규', '신규버튼이 클릭됨')
        conn = db.connect('localHost', 'sa','mssql_p@ss','Madang', charset = 'EUC-KR')
        cursor = conn.cursor(as_dict=True)

        cursor.execute('SELECT * FROM Book')
        for row in cursor:
                print(f'bookid={row["bookid"]}, bookname={row["bookname"]}, publisher={row["publisher"]}, price={row["price"]}')
        
        conn.close()
    
    def btnSaveClocked(self):
        QMessageBox.about(self, '저장', '저장버튼이 클릭됨')
    
    def btnDelClocked(self):
        QMessageBox.about(self, '삭제', '삭제버튼이 클릭됨')
    
    def btnReloadClocked(self):
        QMessageBox.about(self, '조회', '조회버튼이 클릭됨')
    
    def tblBooksSelected(self):
        QMessageBox.about(self, '테이블위젯', '내용 변경')

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

    

