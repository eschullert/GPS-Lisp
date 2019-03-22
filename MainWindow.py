import sys
from PyQt5 import QtWidgets, QtGui, Qt
import subprocess
import time

class Window(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()

        self.init_ui()

    def init_ui(self):
        self.setWindowTitle('GPS')
        self.b=QtWidgets.QPushButton('Buscar Camino')
        self.pic=QtWidgets.QLabel()
        self.pic.setPixmap(QtGui.QPixmap('mapa.jpeg'))
        self.pic.show()

        lst = ['Tijuana', 'Ensenada', 'San Quintin', 'Rosarito', 'Santa Rosalina', 'Loreto', 'La Paz', 'San Lucas',
               'Nogales', 'Hermosillo', 'Guaymas', 'Los Mochis', 'Culiacan', 'Mazatlan', 'Tepic', 'Guadalajara',
               'Manzanillo', 'Lazaro Cardenas', 'Acapulco', 'Puerto Escondido', 'Oaxaca', 'Chilpancingo', 'Cuernavaca',
               'Colima', 'San Luis Potosi', 'Chihuahua', 'Delicias', 'Torreon', 'Durango', 'Zacatecas', 'Saltillo',
               'Monterrey', 'Ciudad Victoria', 'Tampico', 'Poza Rica', 'Veracruz', 'Guanajuato', 'Morelia',
               'Ciudad de Mexico', 'Puebla', 'Villahermosa', 'Merida', 'Cancun', 'Campeche', 'Chetumal']
        self.cboO = QtWidgets.QComboBox()
        self.cboO.clear()
        self.cboO.addItems(lst)
        self.cboD = QtWidgets.QComboBox()
        self.cboD.clear()
        self.cboD.addItems(lst)
        self.res=QtWidgets.QLabel()

        vbox=QtWidgets.QVBoxLayout()
        hbox=QtWidgets.QHBoxLayout()
        vbox.addWidget(self.pic)
        hbox.addWidget(self.cboO)
        hbox.addWidget(self.cboD)
        hbox.addWidget(self.b)
        vbox.addLayout(hbox)
        vbox.addWidget(self.res)
        self.setLayout(vbox)

        self.b.clicked.connect(self.btn_clicked)

        self.show()

    def btn_clicked(self):
        with open('res.txt','w') as f:
            f.write(self.cboO.currentText().replace(' ','')+'\n')
            f.write(self.cboD.currentText().replace(' ',''))
        subprocess.run('/home/eschullert/Documents/Programming/Lisp/GPS/astar.bin', shell=True)
        time.sleep(1)
        with open('res.txt') as f:
            txt=f.read()
            txt=txt[:-2]
            txt=txt.split('\n')
            print(txt)
        st = ''
        dist=txt[0]
        txt=txt[1:]
        for l in txt:
            st += l + ', '
        st[:-2]
        self.res.setText('El camino a seguir es: '+st[:-2]+'. Se recorrerá una distancia de: '+dist)

    #def paintEvent(self, e):
    #    painter=QtGui.QPainter(self)
    #    painter.setPen(QtGui.QPen(Qt.black, 10, Qt.SoldLine))
    #    painter.drawRect(100,15,400,200)

app=QtWidgets.QApplication(sys.argv)
a_window=Window()
sys.exit(app.exec_())





'''
def window():
    app=QtWidgets.QApplication(sys.argv)
    w=QtWidgets.QWidget()
    w.setWindowTitle('GPS')
    map(w)
    addCbo(w)
    addbtn(w)
    #w.setGeometry(500,500,500,400)

    w.show()
    sys.exit(app.exec_())

    def map(self):
        pic=QtWidgets.QLabel(self)
        pic.setPixmap(QtGui.QPixmap("mapa.jpeg"))
        pic.show()

def addCbo(par):
    lst=['Tijuana', 'Ensenada', 'San Quintín', 'Rosarito', 'Santa Rosalina', 'Loreto', 'La Paz', 'San Lucas', 'Nogales', 'Hermosillo', 'Guaymas', 'Los Mochis', 'Culiacan', 'Mazatlán', 'Tepic', 'Guadalajara', 'Manzanillo', 'Lázaro Cárdenas', 'Acapulco', 'Puerto Escondido', 'Oaxaca', 'Chilpancingo', 'Cuernavaca', 'Colima', 'San Luis Potosí', 'Chihuahua', 'Delicias', 'Torréon', 'Durango', 'Zacatecas', 'Saltillo', 'Monterrey', 'Ciudad Victoria', 'Tampico', 'Poza Rica', 'Veracruz', 'Guanajuato', 'Morelia', 'Ciudad de México','Puebla','Villahermosa','Mérida','Cancún','Campeche','Chetumal']
    cboOrigen = QtWidgets.QComboBox(par)
    cboOrigen.clear()
    cboOrigen.addItems(lst)
    cboOrigen.move(0,330)
    cboOrigen.setToolTip('Origen')
    cboDest = QtWidgets.QComboBox(par)
    cboDest.clear()
    cboDest.addItems(lst)
    cboDest.move(0,365)
    cboDest.setToolTip('Destino')
def addbtn(par):
    btn=QtWidgets.QPushButton(par)
    btn.move(0,400)
    btn.resize(140,30)
    btn.setText('Buscar camino')

window()
'''
