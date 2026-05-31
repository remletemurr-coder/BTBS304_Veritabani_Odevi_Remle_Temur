from flask import Flask, render_template
from logic import BusinessLayer

app = Flask(__name__)
bl = BusinessLayer()

@app.route('/')
def index():
    # UI doğrudan veritabanına gidemez, Business katmanını tetikler
    uyeler_listesi = bl.uyeleri_listele()
    return render_template('index.html', uyeler=uyeler_listesi)

if __name__ == '__main__':
    # Debug modu açık, kod değiştikçe otomatik yenilenir
    app.run(debug=True, port=5000)