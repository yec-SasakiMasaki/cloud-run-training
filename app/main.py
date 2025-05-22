from flask import Flask, render_template, request, redirect
import psycopg2
import os


app = Flask(__name__)


def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST", "db"),
        database=os.environ.get("DB_NAME", "flaskapp"),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", "password"),
    )
    conn.autocommit = True
    return conn


def init_db():
    conn = get_db_connection()
    cur = conn.cursor()

    # テーブルが存在しない場合は作成
    cur.execute("""
        CREATE TABLE IF NOT EXISTS messages (
            id SERIAL PRIMARY KEY,
            text VARCHAR(255) NOT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
    """)

    cur.close()
    conn.close()


@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        message = request.form.get("message")
        if message:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute("INSERT INTO messages (text) VALUES (%s)", (message,))
            cur.close()
            conn.close()
        return redirect("/")

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, text, created_at FROM messages ORDER BY created_at DESC")
    messages = cur.fetchall()
    cur.close()
    conn.close()

    return render_template("index.html", messages=messages)


# アプリケーション起動時にDBを初期化
with app.app_context():
    init_db()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
