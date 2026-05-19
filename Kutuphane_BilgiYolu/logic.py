from database import DatabaseLayer

class BusinessLayer:
    def __init__(self):
        self.db_layer = DatabaseLayer()

    def uyeleri_listele(self):
        # İş kuralları burada uygulanır
        return self.db_layer.tum_uyeleri_getir()