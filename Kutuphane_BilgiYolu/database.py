import mysql.connector

class DatabaseLayer:
    def __init__(self):
        try:
            self.db = mysql.connector.connect(
                host="localhost",
                user="root",
                password="your_password", # Buraya şifreniz gelecek
                database="KutuphaneDB"
            )
            self.cursor = self.db.cursor(dictionary=True)
        except:
            self.db = None

    def tum_uyeleri_getir(self):
        # KURAL: Sadece Procedure çağrılır [cite: 70, 166]
        if self.db:
            self.cursor.callproc('sp_UyeListele')
            return [row for result in self.cursor.stored_results() for row in result.fetchall()]
        return [{"UyeID": 1, "Ad": "Remle", "Soyad": "Temur", "UyeTipi": "Öğrenci"}]