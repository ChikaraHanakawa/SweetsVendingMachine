import nfc
import time

class NFCReader:
    def __init__(self):
        self.data_num = None

    def connected(self, tag):
        try:
            idm, pmm = tag.polling(system_code=0x81e1)
            studentcard_pmm = bytearray(b'\x03\x32\x42\x82\x82\x47\xaa\xff')
            tag.idm, tag.pmm, tag.sys = idm, pmm, 0x81e1

            if studentcard_pmm == tag.pmm:
                sc = nfc.tag.tt3.ServiceCode(128, 0x0b)
                bc = nfc.tag.tt3.BlockCode(0, service=0)
                data = tag.read_without_encryption([sc], [bc])
                self.data_num = data.decode('ASCII')
                self.data_num = self.data_num[2:9]
                return True
        except Exception:
            pass
        return False

    def read_student_id(self, timeout=1.0):
        reader = NFCReader()
        deadline = time.time() + timeout
        try:
            with nfc.ContactlessFrontend('usb') as clf:
                clf.connect(rdwr={'on-connect': reader.connected}, terminate=lambda: time.time() > deadline)
            return reader.data_num if reader.data_num else ""
        except Exception as e:
            return f"Error: {str(e)}"
