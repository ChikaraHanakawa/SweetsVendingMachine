import sys
from pathlib import Path
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.load(str(Path(__file__).parent / "Main.qml"))
if not engine.rootObjects():
    sys.exit(-1)
sys.exit(app.exec())
